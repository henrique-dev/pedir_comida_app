import 'dart:async';
import 'dart:convert';

import 'package:action_cable_stream/action_cable_stream.dart';
import 'package:action_cable_stream/action_cable_stream_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/config/transition.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/connection/http_connection.dart';
import 'package:pedir_comida/screens/addresses_screen.dart';
import 'package:pedir_comida/screens/payments_screen.dart';
import 'package:pedir_comida/screens/pre_login_screen.dart';
import 'package:pedir_comida/screens/product_screen.dart';
import 'package:pedir_comida/utils/my_converter.dart';

import '../../../config.dart';
import '../../main_screen.dart';

class SubMainAccount {

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  int _currentSubLevel = 0;
  int _currentCategory = 0;
  State<dynamic> screen;

  SubMainAccount(this.screen);

  resetLevel() {
    _currentSubLevel = 0;
  }

  getSubScreen() {
    switch (_currentSubLevel) {
      case 0:
        return _screenAccount();
    }
  }

  Container _screenAccount() {
    return Container(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Padding(
              padding: EdgeInsets.all(10),
              child: Text("Meus endereços"),
            ),
            onTap: (){
              if (!guestMode()) {
                Navigator.push(this.screen.context, PageTransition(type: PageTransitionType.fade, child: AddressesScreen()));
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Padding(
              padding: EdgeInsets.all(10),
              child: Text("Minhas formas de pagamento (em breve)"),
            ),
            onTap: (){
              if (!guestMode()) {
                Navigator.push(this.screen.context, PageTransition(type: PageTransitionType.fade, child: PaymentsScreen()));
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.transit_enterexit),
            title: Padding(
              padding: EdgeInsets.all(10),
              child: Text("Sair"),
            ),
            onTap: () async {

              Dialogs.showLoadingDialog(this.screen.context, _keyLoader, "Saindo");
              await Connection.logout(this.screen.context);
              final storage = FlutterSecureStorage();
              await storage.deleteAll();
              Config.guestMode = false;
              Navigator.pushAndRemoveUntil(
                  this.screen.context,
                  MaterialPageRoute(
                      builder: (context) => PreLoginScreen()
                  ),
                  ModalRoute.withName("/")
              );
            },
          )
        ],
      ),
    );
  }

  bool guestMode() {
    if (Config.guestMode) {
      showDialog(
          context: this.screen.context,
          builder: (context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Você precisa realizar seu cadastro para usar esta funcionalidade"),
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
      return true;
    }
    return false;
  }
}