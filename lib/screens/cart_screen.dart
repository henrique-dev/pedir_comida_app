import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/config/transition.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/screens/address_screen.dart';
import 'package:pedir_comida/screens/product_screen.dart';
import 'package:pedir_comida/utils/my_converter.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  bool loaded = false;
  bool loadCartMainProducts = true;
  int _addressId = 0;
  int _paymentId = 0;
  Map<String, dynamic> jsonDecoded;
  Map<String, dynamic> cart;
  Map<String, dynamic> taxes;
  Map<int, dynamic> addressesById;
  Map<int, dynamic> paymentsById;

  @override
  void initState() {
    super.initState();
    Connection.get("/user/carts/0.json", callback: cartLoaded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.THEME_COLOR_1,
        title: Text("Carrinho"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (loaded) {
      if (jsonDecoded is Map<String, dynamic>) {

        List payments = jsonDecoded["payments"];
        List<Widget> paymentsWidget = List();
        payments.forEach((element) {

          print(element);

          paymentsWidget.add(
              Transform.scale(
                scale: 0.75,
                alignment: Alignment.centerLeft,
                child: RadioListTile(
                  dense: true,
                  title: Text(element["description"], style: TextStyle(fontSize: 16),),
                  onChanged: (value){
                    setState(() {
                      _paymentId = element["id"];
                    });
                  },
                  value: element["id"],
                  selected: true,
                  groupValue: _paymentId,
                ),
              )
          );
        });


        List addresses = jsonDecoded["addresses"];
        List<Widget> addressesWidget = List();
        addresses.forEach((element) {

          addressesWidget.add(
            Transform.scale(
              scale: 0.75,
              alignment: Alignment.centerLeft,
              child: RadioListTile(
                dense: true,
                title: Text(element["street"], style: TextStyle(fontSize: 16),),
                onChanged: (value){
                  setState(() {
                    _addressId = element["id"];
                  });
                },
                value: element["id"],
                selected: true,
                groupValue: _addressId,
              ),
            )
          );
        });
        addressesWidget.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ButtonTheme(
                  height: 45,
                  child: RaisedButton(
                    onPressed: () async {
                      await Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AddressScreen()));
                      Connection.get("/user/carts/0.json", callback: cartLoaded);
                    },
                    child: Text("Adicionar novo endereço", style: TextStyle(fontSize: 16),),
                    color: MyTheme.THEME_COLOR_1,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black12)
                    ),
                  ),
                ),
              )
            ],
          )
        );



        return Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Entregar em"),
                ),
                Card(
                  child: Theme(
                    data: ThemeData(
                        accentColor: MyTheme.THEME_COLOR_1
                    ),
                    child: ExpansionTile(
                      title: Text("${addressesById[_addressId] != null ? addressesById[_addressId]["street"] : "Toque aqui para adicionar um novo endereço"}", style: TextStyle(color: MyTheme.THEME_COLOR_1),),
                      childrenPadding: EdgeInsets.only(bottom: 0),
                      children: addressesWidget,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Detalhes do pedido"),
                ),
                Card(
                  child: Theme(
                    data: ThemeData(
                        accentColor: MyTheme.THEME_COLOR_1
                    ),
                    child: ExpansionTile(
                      //title: Text("${addressesById[_addressId]["street"]}", style: TextStyle(color: MyTheme.THEME_COLOR_1),),
                      title: getCartMainProducts(jsonDecoded, loadCartMainProducts),
                      childrenPadding: EdgeInsets.only(bottom: 0),
                      children: [getCart(jsonDecoded)],
                      initiallyExpanded: loadCartMainProducts,
                      onExpansionChanged: (value){
                        setState(() {
                          loadCartMainProducts = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Você ira pagar"),
                ),
                Card(
                  child: Theme(
                    data: ThemeData(
                        accentColor: MyTheme.THEME_COLOR_1
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Text("Subtotal", textAlign: TextAlign.left,),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text("R\$", textAlign: TextAlign.right,),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text("${MyConverter.convertPriceUsToBr(jsonDecoded["sub_total"])}", textAlign: TextAlign.right,),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Text("Taxa de entrega", textAlign: TextAlign.left,),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text("R\$", textAlign: TextAlign.right,),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text("${MyConverter.convertPriceUsToBr(this.taxes[addressesById[_addressId]["neighborhood"]])}", textAlign: TextAlign.right,),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: MyTheme.THEME_COLOR_1_LIGHT_3
                                ),
                              )
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Text("Total", textAlign: TextAlign.left, style: TextStyle(fontSize: 18),),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("R\$", textAlign: TextAlign.right,),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text("${MyConverter.convertPriceUsToBr(
                                      MyConverter.sum(
                                          jsonDecoded["total"],
                                          this.taxes[addressesById[_addressId]["neighborhood"]]
                                      ))}", textAlign: TextAlign.right, style: TextStyle(fontSize: 18),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Pagar como"),
                ),
                Card(
                  child: Theme(
                    data: ThemeData(
                        accentColor: MyTheme.THEME_COLOR_1
                    ),
                    child: ExpansionTile(
                      title: Text("${paymentsById[_paymentId]["name"]}", style: TextStyle(color: MyTheme.THEME_COLOR_1),),
                      subtitle: Text("${paymentsById[_paymentId]["description"]}", style: TextStyle(color: MyTheme.THEME_COLOR_1),),
                      childrenPadding: EdgeInsets.only(bottom: 0),
                      children: paymentsWidget,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ButtonTheme(
                    height: 45,
                    child: RaisedButton(
                      onPressed: () {
                        Map<String, dynamic> body = Map<String, dynamic>();
                        body["checkout"] = Map<String, dynamic>();
                        body["checkout"]["address_id"] = _addressId;
                        body["checkout"]["payment_type"] = "physical";
                        body["checkout"]["payment_id"] = _paymentId;

                        Connection.post("/user/carts/checkout.json?", callback: checkout, body: json.encode(body));
                      },
                      child: Text("Confirmar", style: TextStyle(fontSize: 16),),
                      color: MyTheme.THEME_COLOR_1,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.black12)
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );

      } else {
        return Center(
          child: Text("!!"),
        );
      }
    } else {
      return Center(
        child: Text("!!"),
      );
    }
  }

  void checkout(Response response) {
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> jsonDecoded = json.decode(response.body);
        switch(jsonDecoded["status"]) {
          case "success":
            Navigator.pop(context);
            break;
          case "address_not_found":
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Você precisa escolher um endereço para entrega'),
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
            break;
        }
        break;
    }
  }

  void cartLoaded(Response response) {

    if (response.statusCode == 200) {
      jsonDecoded = json.decode(response.body);
      List items = json.decode(jsonDecoded["items"]);

      this.taxes = jsonDecoded["taxes"];

      if (items.isEmpty) {
        Navigator.pop(context);
      }

      List addresses = jsonDecoded["addresses"];
      addressesById = Map<int, dynamic>();
      addresses.forEach((element) {
        if (element["default"]) {
          _addressId = element["id"];
        }
        addressesById[element["id"]] = element;
      });

      List payments = jsonDecoded["payments"];
      paymentsById = Map<int, dynamic>();
      payments.forEach((element) {
        if (element["default"]) {
          _paymentId = element["id"];
        }
        paymentsById[element["id"]] = element;
      });

      loaded = true;
      setState(() {});
    } else {
      Navigator.pop(context);
    }
  }

  Column getCartMainProducts(Map<String, dynamic> data, bool loadCartMainProducts) {
    if (!loadCartMainProducts) {
      List<Widget> widgets = List();
      List items = json.decode(data["items"]);
      items.forEach((product) {
        widgets.add(
            Text("${product["quantity"]} x ${product["name"]}", textAlign: TextAlign.left,)
        );
      });
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgets,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Text("")],
      );
    }
  }

  Column getCart(Map<String, dynamic> data) {

    List items = json.decode(data["items"]);
    List <Widget> widgets = List();
    List <Widget> productsWidgets = List();
    int index = 0;
    items.forEach((product) {

      List <Widget> productWidgets = List();
      //Map<String, dynamic> product = element;
      List complements = product["complements"];
      List <Widget> complementsWidgets = List();
      List variations = product["variations"];
      List <Widget> variationsWidgets = List();
      List ingredients = product["ingredients"];
      List <Widget> ingredientsWidgets = List();

      productWidgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ButtonTheme(
                  height: 35,
                  minWidth: 10,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ProductScreen(product["id"], product["sub_id"])));
                    },
                    child: Icon(Icons.edit),
                    color: MyTheme.THEME_COLOR_1,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black12)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, left: 5),
                child: ButtonTheme(
                  height: 35,
                  minWidth: 10,
                  child: RaisedButton(
                    onPressed: () async {
                      Map<String, dynamic> body = Map<String, dynamic>();
                      body["cart"] = Map<String, dynamic>();
                      body["cart"]["product_id"] = product["id"];
                      body["cart"]["sub_id"] = product["sub_id"];
                      await Connection.post("/user/carts/remove.json", body: json.encode(body));
                      Connection.get("/user/carts/0.json", callback: cartLoaded);
                    },
                    child: Icon(Icons.delete),
                    color: MyTheme.THEME_COLOR_1,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black12)
                    ),
                  ),
                ),
              )
            ],
          )
      );

      productWidgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 8,
                child: Text("${product["quantity"]} x ${product["name"]}", textAlign: TextAlign.left,),
              ),
              Expanded(
                flex: 1,
                child: Text("R\$", textAlign: TextAlign.right,),
              ),
              Expanded(
                flex: 2,
                child: Text("${MyConverter.convertPriceUsToBr(product["price"])}", textAlign: TextAlign.right,),
              ),
            ],
          )
      );
      if (complements.isNotEmpty) {
        productWidgets.add(
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Complementos: ", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
            )
        );
        complements.forEach((complement) {
          complementsWidgets.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(complement["name"], textAlign: TextAlign.left,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("R\$", textAlign: TextAlign.right,),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("${MyConverter.convertPriceUsToBr(complement["price"])}", textAlign: TextAlign.right,),
                  ),
                ],
              )
          );
        });
        productWidgets.add(
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: complementsWidgets,
              ),
            )
        );
      }

      if (ingredients.isNotEmpty) {
        productWidgets.add(
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Retirar ingredientes: ", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
            )
        );
        ingredients.forEach((ingredient) {
          ingredientsWidgets.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(ingredient["name"], textAlign: TextAlign.left,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("R\$", textAlign: TextAlign.right,),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("${MyConverter.convertPriceUsToBr(ingredient["price"])}", textAlign: TextAlign.right,),
                  ),
                ],
              )
          );
        });
        productWidgets.add(
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: ingredientsWidgets,
              ),
            )
        );
      }

      if (variations.isNotEmpty) {
        productWidgets.add(
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text("Variações: ", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
            )
        );
        variations.forEach((variation) {
          variationsWidgets.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(variation["name"], textAlign: TextAlign.left,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("R\$", textAlign: TextAlign.right,),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("${MyConverter.convertPriceUsToBr(variation["price"])}", textAlign: TextAlign.right,),
                  ),
                ],
              )
          );
        });
        productWidgets.add(
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: variationsWidgets,
              ),
            )
        );
      }

      productsWidgets.add(
          Container(
            decoration: BoxDecoration(
                border: index == items.length-1 ? null : Border(
                  bottom: BorderSide(
                      color: MyTheme.THEME_COLOR_1_LIGHT_2
                  ),
                )
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: productWidgets,
              ),
            ),
          )
      );

      index++;
    });

    widgets.add(Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: productsWidgets,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

}
