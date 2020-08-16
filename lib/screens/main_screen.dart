import 'dart:convert';

import 'package:action_cable_stream/action_cable_stream.dart';
import 'package:action_cable_stream/action_cable_stream_states.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/config/transition.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/connection/http_connection.dart';
import 'package:pedir_comida/screens/cart_screen.dart';
import 'package:pedir_comida/screens/pre_login_screen.dart';
import 'package:pedir_comida/screens/product_screen.dart';
import 'package:pedir_comida/screens/sub/main/sub_main_account.dart';
import 'package:pedir_comida/screens/sub/main/sub_main_find.dart';
import 'package:pedir_comida/screens/sub/main/sub_main_order.dart';
import 'package:pedir_comida/utils/my_converter.dart';

import '../config.dart';

class MainScreen extends StatefulWidget {

  int _currentBottomNavigationBarIndex = 0;

  MainScreen({int currentBottomNavigationBarIndex = 0}) {
    this._currentBottomNavigationBarIndex = currentBottomNavigationBarIndex;
  }

  @override
  _MainScreenState createState() => _MainScreenState(currentBottomNavigationBarIndex: this._currentBottomNavigationBarIndex);
}

class _MainScreenState extends State<MainScreen> {

  int _currentBottomNavigationBarIndex = 0;
  SubMainFind _subMainFindScreen;
  SubMainOrder _subMainOrderScreen;
  SubMainAccount _subMainAccount;
  Map<String, dynamic> cart;
  //WebSocketChannel _channel;
  ActionCable _cable;

  _MainScreenState({int currentBottomNavigationBarIndex = 0}) {
    this._currentBottomNavigationBarIndex = currentBottomNavigationBarIndex;
  }

  @override
  void initState() {
    super.initState();
    _subMainFindScreen = SubMainFind(this);
    _subMainOrderScreen = SubMainOrder(this);
    _subMainAccount = SubMainAccount(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: getSubScreen(_currentBottomNavigationBarIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          resetSubScreen(index);
          setState(() {
            _currentBottomNavigationBarIndex = index;
          });
        },
        currentIndex: _currentBottomNavigationBarIndex,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(
          color: MyTheme.THEME_COLOR_1,
        ),
        selectedItemColor: MyTheme.THEME_COLOR_1,
        items: [
          BottomNavigationBarItem(
            title: Text("Buscar"),
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            title: Text("Pedidos"),
            icon: Icon(Icons.receipt),
          ),
          BottomNavigationBarItem(
            title: Text("Conta"),
            icon: Icon(Icons.account_circle),
          )
        ],
      ),
      floatingActionButton: FutureBuilder<dynamic>(
        future: Config.guestMode ? Future.delayed(Duration(seconds: 2)).then((_){

        }) : Connection.get("/user/carts/0.json?only_total=true", context, callback: null),
        builder: (context, snapshot) {

          Map<String, dynamic> jsonDecoded;
          Map<String, dynamic> cart;

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              CircularProgressIndicator();
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (!snapshot.hasError) {

                Response response = snapshot.data;

                if (!Config.guestMode) {

                  jsonDecoded = json.decode(response.body);
                  cart = jsonDecoded["cart"];

                  if (cart != null) {
                    if (cart["locked"]) {
                      openSocket();

                      if (_currentBottomNavigationBarIndex != 1) {
                        return RaisedButton(
                          onPressed: (){
                            setState(() {
                              _currentBottomNavigationBarIndex = 1;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10, left: 0),
                                  child: Icon(Icons.access_time, color: Colors.white,),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text("Acompanhar pedido", style: TextStyle(color: Colors.white),),
                                ),
                              ],
                            ),
                          ),
                          color: MyTheme.THEME_COLOR_1,
                        );
                      }
                    } else if (cart is Map<String, dynamic>) {
                      if (cart["total"] != null && double.tryParse(cart["total"]) > 0) {
                        return ButtonTheme(
                          height: 35,
                          minWidth: 10,
                          child: RaisedButton(
                            onPressed: () async {
                              await Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CartScreen()));
                              resetSubScreen(_currentBottomNavigationBarIndex);
                              setState(() {});
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.black12)
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10, left: 0),
                                    child: Icon(Icons.shopping_cart, color: Colors.white,),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text("Ver carrinho", style: TextStyle(color: Colors.white),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 0),
                                    child: Text("R\$ ${MyConverter.convertPriceUsToBr(cart["total"])}", style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                              ),
                            ),
                            color: MyTheme.THEME_COLOR_1,
                          ),
                        );
                      }
                    }
                  } else {
                    return Text("");
                  }
                } else {
                  return RaisedButton(
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => PreLoginScreen()),
                        ModalRoute.withName('/'),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 15, left: 0),
                            child: Icon(Icons.sentiment_very_satisfied, color: Colors.white,),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Realizar cadastro", style: TextStyle(color: Colors.white),),
                          )
                        ],
                      ),
                    ),
                    color: MyTheme.THEME_COLOR_1,
                  );
                }
              }
              break;
          }
          return Center(
            child: Text(""),
          );
        },
      )
    );
  }

  void setCart(Map<String, dynamic> cart) {
    //this.cart = cart;
  }

  dynamic getSubScreen(int index) {
    switch (index) {
      case 0:
        return _subMainFindScreen.getSubScreen(setCart);
      case 1:
        return _subMainOrderScreen.getSubScreen(setCart);
      case 2:
        return _subMainAccount.getSubScreen();
      case 3:
        break;
    }
  }

  resetSubScreen(int index) {
    switch (index) {
      case 0:
        _subMainFindScreen.resetLevel();
        break;
      case 1:
        _subMainOrderScreen.resetLevel();
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  void openSocket() {
    final String _channel = 'UserChannel';
    _cable = ActionCable.Stream(HttpConnection.hostWs, headers: Connection.accessHeaders);
    _cable.stream.listen((value) {
      if (value is ActionCableConnected) {
        print('ActionCableConnected');
        _cable.subscribeToChannel(_channel);
      } else if (value is ActionCableSubscriptionConfirmed) {
        print('ActionCableSubscriptionConfirmed');
        //_cable.performAction(_channel, 'send_message', channelParams: {'id': 1}, actionParams: {'body': 'hello world'});
      } else if (value is ActionCableMessage) {
        Map<String, dynamic> jsonDecoded = value.message;
        print(jsonDecoded);
        if (jsonDecoded["category"] == "order_status_change") {
          setState(() {

          });
          //_subMainOrderScreen.changeCurrentOrderStatus(jsonDecoded["message"]);
        }
      }
    });
  }

}
