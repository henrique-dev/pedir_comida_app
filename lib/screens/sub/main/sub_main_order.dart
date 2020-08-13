import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:pedir_comida/config/constants.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/utils/my_converter.dart';

import '../../main_screen.dart';

class SubMainOrder {

  int _currentSubLevel = 0;
  int _currentCategory = 0;
  State<dynamic> screen;

  SubMainOrder(this.screen);

  resetLevel() {
    _currentSubLevel = 0;
  }

  getSubScreen(Function setCart) {
    switch (_currentSubLevel) {
      case 0:
        return _screenOrder(setCart);
    }
  }

  changeCurrentOrderStatus(String status) {

  }

  FutureBuilder<dynamic> _screenOrder(Function setCart) {
    return FutureBuilder<dynamic>(
      future: Connection.get("/user/orders.json", callback: null),
      builder: (context, snapshot) {

        Map<String, dynamic> jsonDecoded;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Center(child: Loading(indicator: BallPulseIndicator(), size: 50.0, color: MyTheme.THEME_COLOR_1_LIGHT_2),);
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (!snapshot.hasError) {

              Response response = snapshot.data;

              if (response.statusCode == 401) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Não há pedidos para exibir", textAlign: TextAlign.center,)
                  ],
                );
              } else {
                jsonDecoded = json.decode(response.body);

                if (jsonDecoded is Map<String, dynamic>) {

                  List<Widget> widgets = List();
                  Map<String, dynamic> currentOrder = jsonDecoded["current_order"];
                  List<dynamic> oldOrders = jsonDecoded["old_orders"];

                  if (currentOrder != null) {
                    widgets.add(
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Seu pedido atual:"),
                      )
                    );
                    widgets.add(
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text("Status: ${ Constants.ORDER_STATUS[currentOrder["checkout"]["status"]]}"),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text("Entregar em: ${currentOrder["address"]["street"]}"),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text("Forma de pagamento: ${currentOrder["checkout"]["payment_method"]["description"]}"),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text("Total: R\$ ${MyConverter.convertPriceUsToBr(currentOrder["cart"]["total"])}", textAlign: TextAlign.right,),
                              ),
                            ],
                          ),
                        )
                      )
                    );
                  }

                  if (oldOrders != null && oldOrders.length > 0) {
                    widgets.add(
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Pedidos concluídos:"),
                        )
                    );
                    oldOrders.forEach((element) {
                      widgets.add(
                          Card(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Text("Status: ${Constants.ORDER_STATUS[element["status"]]}"),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              ButtonTheme(
                                                height: 35,
                                                minWidth: 10,
                                                child: RaisedButton(
                                                  onPressed: () async {
                                                    Map<String, dynamic> body = Map<String, dynamic>();
                                                    body["order"] = Map<String, dynamic>();
                                                    body["order"]["id"] = element["id"];
                                                    await Connection.post("/user/carts/repurchase.json", callback: repurchaseCallback, body: json.encode(body));
                                                  },
                                                  //child: Text("Pedir novamente", style: TextStyle(fontSize: 16),),
                                                  child: Icon(Icons.shopping_cart),
                                                  color: MyTheme.THEME_COLOR_1,
                                                  textColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                      side: BorderSide(color: Colors.black12)
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Text("Entregue em: ${element["address"]["street"]}"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Text("Pago com: ${element["payment_method"]["description"]}"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Text("Total: R\$ ${MyConverter.convertPriceUsToBr(element["items"]["total"])}", textAlign: TextAlign.right,),
                                    ),
                                  ],
                                ),
                              )
                          )
                      );
                    });
                  }

                  if (widgets.length > 0) {
                    return ListView.builder(
                        itemCount: widgets.length,
                        itemBuilder: (context, index) {
                          return widgets[index];
                        }
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Não há pedidos para exibir", textAlign: TextAlign.center,)
                      ],
                    );
                  }
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Não há pedidos para exibir", textAlign: TextAlign.center,)
                    ],
                  );
                }
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

  void repurchaseCallback(Response response) {
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecoded = json.decode(response.body);
      if (jsonDecoded["success"]) {
        Navigator.pushAndRemoveUntil(
            this.screen.context,
            MaterialPageRoute(
                builder: (context) => MainScreen(currentBottomNavigationBarIndex: 0)
            ),
            ModalRoute.withName("/")
        );
      } else if (!jsonDecoded["success"] && jsonDecoded["control"] == "locked"){
        showDialog(
            context: this.screen.context,
            builder: (context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Já existe um pedido em andamento.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    color: MyTheme.THEME_COLOR_1,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
        );
      }
    }
  }
}