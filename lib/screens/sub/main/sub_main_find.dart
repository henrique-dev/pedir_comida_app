import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/config/transition.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/connection/http_connection.dart';
import 'package:pedir_comida/screens/product_screen.dart';
import 'package:pedir_comida/utils/my_converter.dart';

class SubMainFind {

  int _currentSubLevel = 0;
  int _currentCategory = 0;
  State<dynamic> screen;

  SubMainFind(this.screen);

  resetLevel() {
    _currentSubLevel = 0;
  }

  getSubScreen(Function setCart) {
    switch (_currentSubLevel) {
      case 0:
        return _screenFind(setCart);
      case 1:
        return _screenFindByCategory(setCart);
    }
  }

  FutureBuilder<dynamic> _screenFind(Function setCart) {
    return FutureBuilder<dynamic>(
      future: Connection.get("/user/categories.json", this.screen.context, callback: null),
      builder: (context, snapshot) {

        Map<String, dynamic> jsonDecoded;
        List<dynamic> categoriesJSON;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Center(child: Loading(indicator: BallPulseIndicator(), size: 50.0,color: MyTheme.THEME_COLOR_1_LIGHT_2),);
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (!snapshot.hasError) {

              Response response = snapshot.data;
              jsonDecoded = json.decode(response.body);
              categoriesJSON = jsonDecoded["categories"];
              setCart(jsonDecoded["cart"]);

              if (categoriesJSON is List<dynamic>) {

                if (categoriesJSON.length > 0) {
                  return ListView.builder(
                      itemCount: categoriesJSON.length,
                      itemBuilder: (context, index) {

                        Widget img = Image.asset("assets/images/coming-soon.jpg",
                          height: 100,
                          fit: BoxFit.contain,);
                        /*if (categoriesJSON[index]["photo"] != null) {
                            img = Image.network(
                              HttpConnection.host + categoriesJSON[index]["photo"],
                              height: 100,
                              fit: BoxFit.cover,);
                          }*/
                        if (categoriesJSON[index]["photo"] != null) {
                          img = CachedNetworkImage(
                            imageUrl: HttpConnection.host + categoriesJSON[index]["photo"],
                            height: 100,
                            fit: BoxFit.cover,);
                        }


                        return InkWell(
                          onTap: () {
                            _currentSubLevel++;
                            _currentCategory = categoriesJSON[index]["id"];
                            screen.setState(() {});
                          },
                          child: Card(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Stack(
                                      fit: StackFit.passthrough,
                                      children: [
                                        img,
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: MyTheme.THEME_COLOR_1_LIGHT,
                                              ),
                                              child: Text(
                                                categoriesJSON[index]["name"], textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Nenhum produto para exibir", textAlign: TextAlign.center,)
                    ],
                  );
                }
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Nenhum produto para exibir", textAlign: TextAlign.center,)
                  ],
                );
              }
            } else {

            }
            break;
        }
        return Center(
          child: Text(""),
        );
      },
    );
  }

  FutureBuilder<dynamic> _screenFindByCategory(Function setCart) {
    return FutureBuilder<dynamic>(
      future: Connection.get("/user/products.json?category=${this._currentCategory}", this.screen.context, callback: null),
      builder: (context, snapshot) {

        Map<String, dynamic> jsonDecoded;
        List<dynamic> productsJSON;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Center(child: Loading(indicator: BallPulseIndicator(), size: 50.0,color: MyTheme.THEME_COLOR_1_LIGHT_2),);
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (!snapshot.hasError) {

              Response response = snapshot.data;

              jsonDecoded = json.decode(response.body);
              productsJSON = jsonDecoded["products"];

              if (productsJSON is List<dynamic>) {
                if (productsJSON.length > 0) {
                  return ListView.builder(
                      itemCount: productsJSON.length,
                      itemBuilder: (context, index) {

                        Widget img = Image.asset("assets/images/coming-soon.jpg",
                          height: 100,
                          fit: BoxFit.fill,);
                        /*if (productsJSON[index]["photo"] != null) {
                          img = Image.network(
                            HttpConnection.host + productsJSON[index]["photo"],
                            height: 100,
                            fit: BoxFit.cover,);
                        }*/
                        if (productsJSON[index]["photo"] != null) {
                          img = CachedNetworkImage(
                            imageUrl: HttpConnection.host + productsJSON[index]["photo"],
                            height: 100,
                            fit: BoxFit.cover,);
                        }

                        return InkWell(
                          onTap: () {
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ProductScreen(productsJSON[index]["id"], 0)));
                          },
                          child: Card(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        img,
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            productsJSON[index]["name"], textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              productsJSON[index]["complements"] == 0 ? Text("") : Chip(
                                                backgroundColor: MyTheme.THEME_COLOR_1_LIGHT,
                                                elevation: 5,
                                                labelStyle: TextStyle(
                                                  color: Colors.white
                                                ),
                                                padding: EdgeInsets.all(5),
                                                labelPadding: EdgeInsets.all(0),
                                                label: Text("complementos"),
                                              ),
                                              productsJSON[index]["variations"] == 0 ? Text("") : Chip(
                                                backgroundColor: MyTheme.THEME_COLOR_1_LIGHT,
                                                elevation: 5,
                                                labelStyle: TextStyle(
                                                    color: Colors.white
                                                ),
                                                padding: EdgeInsets.all(5),
                                                labelPadding: EdgeInsets.all(0),
                                                label: Text("variações"),
                                              ),
                                              productsJSON[index]["ingredients"] == 0 ? Text("") : Chip(
                                                backgroundColor: MyTheme.THEME_COLOR_1_LIGHT,
                                                elevation: 5,
                                                labelStyle: TextStyle(
                                                    color: Colors.white
                                                ),
                                                padding: EdgeInsets.all(5),
                                                labelPadding: EdgeInsets.all(0),
                                                label: Text("ingredientes"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            "R\$ ${MyConverter.convertPriceUsToBr(productsJSON[index]["price"])}", textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 18
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Nenhum produto para exibir", textAlign: TextAlign.center,)
                    ],
                  );
                }
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Nenhum produto para exibir", textAlign: TextAlign.center,)
                  ],
                );
              }
            }
            break;
        }
        return Center(
          child: Text(""),
        );
      },
    );
  }
}