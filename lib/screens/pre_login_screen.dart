import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/config/transition.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/models/user.dart';
import 'package:pedir_comida/screens/login_screen.dart';

import '../config.dart';
import 'main_screen.dart';

class PreLoginScreen extends StatefulWidget {

  bool _checkToken;

  PreLoginScreen({check_token: true}) {
    this._checkToken = check_token;
  }

  @override
  _PreLoginScreenState createState() => _PreLoginScreenState(this._checkToken);
}

class _PreLoginScreenState extends State<PreLoginScreen> {

  final bool _checkToken;

  _PreLoginScreenState(this._checkToken);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkToken(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(child: Loading(indicator: BallPulseIndicator(), size: 50.0,color: MyTheme.THEME_COLOR_1_LIGHT_2),);
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.data != null) {
                if (snapshot.data) {
                  return MainScreen();
                } else {

                }
              } else {

              }
              break;
          }
          return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.fill
                ),
              ),
              child: Container(
                color: MyTheme.THEME_COLOR_1_LIGHT_2,
                margin: EdgeInsets.all(1),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/images/splash_logo.png"),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: ButtonTheme(
                              height: 50,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: LoginScreen()));
                                },
                                child: Text("Entrar", style: TextStyle(fontSize: 16),),
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
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: ButtonTheme(
                              height: 50,
                              child: RaisedButton(
                                onPressed: () {
                                  Config.guestMode = true;
                                  Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: MainScreen()));
                                },
                                child: Text("Convidado", style: TextStyle(fontSize: 16),),
                                color: Colors.white,
                                textColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(color: Colors.black12)
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
        },
      )
    );
  }

  Future<bool> checkToken() async {
    if (!_checkToken) {
      return false;
    }
    final storage = FlutterSecureStorage();
    //storage.deleteAll();
    String value = await storage.read(key: "user_login");
    if (value != null) {
      Map<String, dynamic> jsonDecoded = json.decode(value);
      Connection.accessHeaders["access-token"] = jsonDecoded["access-token"];
      Connection.accessHeaders["uid"] = jsonDecoded["uid"];
      Connection.accessHeaders["client"] = jsonDecoded["client"];

      var body = {};
      body["register"] = {};
      body["register"]["access_token"] = jsonDecoded["access-token"];
      body["register"]["uid"] = jsonDecoded["uid"];
      body["register"]["client"] = jsonDecoded["client"];
      Response response = await Connection.post("/user/register/check_token", context, body: json.encode(body));
      jsonDecoded = json.decode(response.body);
      if (response.statusCode == 200) {
        if (jsonDecoded["success"]) {
          return true;
        } else {
          storage.deleteAll();
        }
      }
    }
    return false;
  }
}
