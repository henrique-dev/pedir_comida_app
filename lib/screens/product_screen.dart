import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pedir_comida/config.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/connection/http_connection.dart';
import 'package:pedir_comida/utils/my_converter.dart';

import 'main_screen.dart';

class ProductScreen extends StatefulWidget {

  final int _productId;
  final int _subId;

  ProductScreen(this._productId, this._subId);

  @override
  _ProductScreenState createState() => _ProductScreenState(this._productId, this._subId);
}

class _ProductScreenState extends State<ProductScreen> {

  bool loaded = false;
  Map<String, dynamic> jsonDecoded;

  List complements;
  List ingredients;
  List variations;
  Map myComplements = {};
  Map myIngredients = {};
  Map myVariations = {};

  int complementsSelected = 0;
  int ingredientsSelected = 0;
  int variationsSelected = 0;

  int quantity = 1;

  Decimal total = Decimal.fromInt(0);

  final int _productId;
  final int _subId;

  _ProductScreenState(this._productId, this._subId);

  @override
  void initState() {
    super.initState();
    Connection.get("/user/products/${this._productId}.json?sub_id=${this._subId}", this.context, callback: productLoaded);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: getBody(),
      bottomSheet: Container(
        padding: EdgeInsets.all(20),
        color: MyTheme.THEME_COLOR_1,
        child: InkWell(
          onTap: (){
            if (!Config.guestMode) {
              if (checkRequisites()) {
                Map<String, dynamic> body = Map<String, dynamic>();
                body["cart"] = Map<String, dynamic>();
                body["cart"]["product_id"] = this._productId;
                body["cart"]["sub_id"] = this._subId;
                body["cart"]["quantity"] = quantity;
                body["cart"].addAll(getOnlyNeededRequisites());
                if (this._subId == 0) {
                  Connection.post("/user/carts/add.json?", context, callback: productAdded, body: json.encode(body));
                } else {
                  Connection.post("/user/carts/update_item.json?", context, callback: productAdded, body: json.encode(body));
                }
              }
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("Você precisa realizar seu cadastro para adicionar um produto ao carrinho"),
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
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Adicionar ao carrinho", style: TextStyle(color: Colors.white),),
              Text("Total: R\$ ${MyConverter.convertPriceUsToBr((Decimal.fromInt(quantity) * Decimal.parse(total.toString())).toString()) }",
                style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    if (loaded) {
      if (jsonDecoded.length > 0) {

        Widget img = Image.asset("assets/images/coming-soon.jpg", height: 100,
          fit: BoxFit.cover,);
        /*if (jsonDecoded["photo"] != null) {
          img = Image.network(
            HttpConnection.host + jsonDecoded["photo"],
            height: 100,
            fit: BoxFit.cover,);
        }*/
        if (jsonDecoded["photo"] != null) {
          img = CachedNetworkImage(
            imageUrl: HttpConnection.host + jsonDecoded["photo"],
            height: 100,
            fit: BoxFit.cover,);
        }

        List<Widget> widgetComplements = [];
        complements.forEach((element) {
          widgetComplements.add(
              CheckboxListTile(
                onChanged: complementsSelected >= jsonDecoded["max_complements"] && !myComplements[element["name"]]["v"] ? null : (bool value) {
                  if (value) {
                    total += Decimal.parse(element["price"]);
                    complementsSelected++;
                  } else {
                    total -= Decimal.parse(element["price"]);
                    complementsSelected--;
                  }
                  setState(() {
                    myComplements[element["name"]]["v"] = value;
                  });
                },
                value: myComplements[element["name"]]["v"],
                title: Text(element["name"]),
                subtitle: Text(MyConverter.convertPriceUsToBr(element["price"])),
                checkColor: Colors.white,
                activeColor: MyTheme.THEME_COLOR_1,
                contentPadding: EdgeInsets.only(left: 35, right: 10),
              )
          );
        });

        List<Widget> widgetIngredients = [];
        ingredients.forEach((element) {
          widgetIngredients.add(
              CheckboxListTile(
                onChanged: ingredientsSelected >= jsonDecoded["max_ingredients"] && !myIngredients[element["name"]]["v"] ? null : (bool value) {
                  if (value) {
                    total += Decimal.parse(element["price"]);
                    ingredientsSelected++;
                  } else {
                    total -= Decimal.parse(element["price"]);
                    ingredientsSelected--;
                  }
                  setState(() {
                    myIngredients[element["name"]]["v"] = value;
                  });
                },
                value: myIngredients[element["name"]]["v"],
                title: Text(element["name"]),
                subtitle: Text(MyConverter.convertPriceUsToBr(element["price"])),
                checkColor: Colors.white,
                activeColor: MyTheme.THEME_COLOR_1,
                contentPadding: EdgeInsets.only(left: 35, right: 10),
              )
          );
        });

        List<Widget> widgetVariations = [];
        variations.forEach((element) {
          widgetVariations.add(
              CheckboxListTile(
                onChanged: variationsSelected >= jsonDecoded["max_variations"] && !myVariations[element["name"]]["v"] ? null : (bool value) {
                  if (value) {
                    total += Decimal.parse(element["price"]);
                    variationsSelected++;
                  } else {
                    total -= Decimal.parse(element["price"]);
                    variationsSelected--;
                  }
                  setState(() {
                    myVariations[element["name"]]["v"] = value;
                  });
                },
                value: myVariations[element["name"]]["v"],
                title: Text(element["name"]),
                subtitle: Text(MyConverter.convertPriceUsToBr(element["price"])),
                checkColor: Colors.white,
                activeColor: MyTheme.THEME_COLOR_1,
                contentPadding: EdgeInsets.only(left: 35, right: 10),
              )
          );
        });

        List<ExpansionTile> expansionTiles = [];
        if (complements.length > 0) {
          expansionTiles.add(
            ExpansionTile(
              title: Text("Complementos", style: TextStyle(color: MyTheme.THEME_COLOR_1),),
              subtitle: Text("Escolha pelo menos ${jsonDecoded["min_complements"]} (Máx. ${jsonDecoded["max_complements"]})",
                style: TextStyle(color: MyTheme.THEME_COLOR_1),),
              initiallyExpanded: true,
              children: widgetComplements,
            )
          );
        }
        if (ingredients.length > 0) {
          expansionTiles.add(
              ExpansionTile(
                title: Text("Ingredientes", style: TextStyle(color: MyTheme.THEME_COLOR_1),),
                subtitle: Text("Escolha no máximo ${jsonDecoded["max_ingredients"]}",
                  style: TextStyle(color: MyTheme.THEME_COLOR_1),),
                initiallyExpanded: true,
                children: widgetIngredients,
              )
          );
        }
        if (variations.length > 0) {
          expansionTiles.add(
              ExpansionTile(
                title: Text("Variações", style: TextStyle(color: MyTheme.THEME_COLOR_1),),
                subtitle: Text("Escolha pelo menos ${jsonDecoded["min_variations"]} (Máx. ${jsonDecoded["max_variations"]})",
                  style: TextStyle(color: MyTheme.THEME_COLOR_1),),
                initiallyExpanded: true,
                children: widgetVariations,
              )
          );
        }

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                snap: false,
                expandedHeight: 250.0,
                backgroundColor: MyTheme.THEME_COLOR_1,
                flexibleSpace: FlexibleSpaceBar(
                  background: img,
                ),
                title: Text(jsonDecoded["name"]),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, int index) {
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                jsonDecoded["name"], textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "R\$ ${MyConverter.convertPriceUsToBr(jsonDecoded["price"])}", textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Theme(
                                data: ThemeData(
                                    accentColor: MyTheme.THEME_COLOR_1
                                ),
                                child: Column(
                                  children: expansionTiles,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, top: 20, right: 5, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Quantidade: ", style: TextStyle(fontSize: 16),),
                                  Row(
                                    children: [
                                      FlatButton(
                                        onPressed: quantity <= 1 ? null : (){
                                          setState(() {
                                            quantity--;
                                          });
                                        },
                                        child: Icon(Icons.remove),
                                        shape: CircleBorder(
                                            side: BorderSide(color: Colors.black12)
                                        ),
                                      ),
                                      Text("${this.quantity}", style: TextStyle(fontSize: 18),),
                                      FlatButton(
                                        onPressed: (){
                                          setState(() {
                                            quantity++;
                                          });
                                        },
                                        child: Icon(Icons.add),
                                        shape: CircleBorder(
                                            side: BorderSide(color: Colors.black12)
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              color: MyTheme.THEME_COLOR_1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total:", style: TextStyle(color: Colors.white),),
                                  Text("R\$ ${MyConverter.convertPriceUsToBr((Decimal.fromInt(0) * Decimal.parse(total.toString())).toString())}",
                                    style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: 1,
                  )
              ),
            ],
          ),
        );
        /*return SingleChildScrollView(
            child:
        );*/
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
      return Text("");
    }
  }

  bool checkRequisites() {
    if (complementsSelected < jsonDecoded["min_complements"]) {
      return false;
    }
    if (variationsSelected < jsonDecoded["min_variations"]) {
      return false;
    }
    return true;
  }

  Map<String, List> getOnlyNeededRequisites() {
    Map<String, List> requisites = Map<String, List>();
    requisites["complements"] = [];
    requisites["variations"] = [];
    requisites["ingredients"] = [];
    myComplements.forEach((key, value) {
      if (value["v"]) {
        requisites["complements"].add(value["id"]);
      }
    });
    myVariations.forEach((key, value) {
      if (value["v"]) {
        requisites["variations"].add(value["id"]);
      }
    });
    myIngredients.forEach((key, value) {
      if (!value["v"]) {
        requisites["ingredients"].add(value["id"]);
      }
    });
    return requisites;
  }

  void productAdded(Response response) {
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecoded = json.decode(response.body);
      if (jsonDecoded["success"]) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(currentBottomNavigationBarIndex: 0)
            ),
            ModalRoute.withName("/")
        );
      } else if (!jsonDecoded["success"] && jsonDecoded["control"] == "locked"){
         showDialog(
           context: context,
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
    } else {

    }
  }

  void productLoaded(Response response) {
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      if (body is Map<String, dynamic>) {

        total = Decimal.fromInt(0);

        jsonDecoded = json.decode(response.body);

        Map<String, dynamic> productFromCart = jsonDecoded["product_from_cart"];

        complements = jsonDecoded["complements"];
        variations = jsonDecoded["variations"];
        ingredients = jsonDecoded["ingredients"];

        if (productFromCart != null) {
          this.quantity = productFromCart["quantity"];
        }

        complements.forEach((element) {
          myComplements[element["name"]] = {};
          if (productFromCart != null && productFromCart["complements"] != null) {
            List complementsFromCart = productFromCart["complements"];
            if (complementsFromCart.contains(element["id"])) {
              complementsSelected++;
              total += Decimal.tryParse(element["price"].toString());
              myComplements[element["name"]]["v"] = true;
            } else {
              myComplements[element["name"]]["v"] = false;
            }
          } else {
            myComplements[element["name"]]["v"] = false;
          }
          myComplements[element["name"]]["id"] = element["id"];
        });
        variations.forEach((element) {
          myVariations[element["name"]] = {};
          if (productFromCart != null && productFromCart["variations"] != null) {
            List variationsFromCart = productFromCart["variations"];
            if (variationsFromCart.contains(element["id"])) {
              variationsSelected++;
              total += Decimal.tryParse(element["price"].toString());
              myVariations[element["name"]]["v"] = true;
            } else {
              myVariations[element["name"]]["v"] = false;
            }
          } else {
            myVariations[element["name"]]["v"] = false;
          }
          myVariations[element["name"]]["id"] = element["id"];
        });
        ingredients.forEach((element) {
          myIngredients[element["name"]] = {};
          if (productFromCart != null && productFromCart["ingredients"] != null) {
            List ingredientsFromCart = productFromCart["ingredients"];
            if (ingredientsFromCart.contains(element["id"])) {
              ingredientsSelected++;
              total -= Decimal.tryParse(element["price"].toString());
              myIngredients[element["name"]]["v"] = false;
            } else {
              myIngredients[element["name"]]["v"] = true;
            }
          } else {
            myIngredients[element["name"]]["v"] = true;
          }
          myIngredients[element["name"]]["id"] = element["id"];
        });

        total += Decimal.parse(jsonDecoded["price"]);
      } else {
        return;
      }
      loaded = true;
      setState(() {});
    } else {
      Navigator.pop(context);
    }
  }
}
