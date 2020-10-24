import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/models/user.dart';
import 'package:pedir_comida/screens/pre_login_screen.dart';

import '../config.dart';
import 'http_connection.dart';

class Connection {

  static var accessHeaders = {
    "access-token" : "",
    "client" : "",
    "uid" : ""
  };

  static Future<dynamic> get(String path, BuildContext context, {Function callback,
    Map<String, String> headers}) async {
    if (headers == null) {
      headers = {
        "Content-Type" : "application/json; charset=UTF-8"
      };
    }
    headers.addAll(accessHeaders);
    dynamic response;
    String param = "";
    try {
      response = await HttpConnection.get(path, headers: headers).timeout(Duration(seconds: 5));
    } on TimeoutException catch(e) {
     response = Response("{}", 408);
    } on SocketException catch(e) {
      param = "SocketException";
      response = Response("{}", 408);
    }
    checkStatusCode(context, response, param: param);
    preCallback(response, callback);
    return response;
  }

  static Future<dynamic> post(String path, BuildContext context, {Function callback,
    Map<String, String> headers, dynamic body}) async {
    if (headers == null) {
      headers = {
        "Content-Type" : "application/json; charset=UTF-8"
      };
    }
    headers.addAll(accessHeaders);
    dynamic response;
    String param = "";
    try {
      response = await HttpConnection.post(path, headers: headers, body: body).timeout(Duration(seconds: 5));
    } on TimeoutException catch(e) {
      response = Response("{}", 408);
    } on SocketException catch(e) {
      param = "SocketException";
      response = Response("{}", 408);
    }
    checkStatusCode(context, response, param: param);
    preCallback(response, callback);
    return response;
  }

  static Future<dynamic> patch(String path, BuildContext context, {Function callback,
    Map<String, String> headers, dynamic body}) async {
    if (headers == null) {
      headers = {
        "Content-Type" : "application/json; charset=UTF-8"
      };
    }
    headers.addAll(accessHeaders);
    dynamic response = await HttpConnection.patch(path, headers: headers, body: body);
    checkStatusCode(context, response);
    preCallback(response, callback);
    return response;
  }

  static Future<dynamic> delete(String path, BuildContext context, {Function callback,
    Map<String, String> headers, dynamic body}) async {
    if (headers == null) {
      headers = {
        "Content-Type" : "application/json; charset=UTF-8"
      };
    }
    headers.addAll(accessHeaders);
    dynamic response = await HttpConnection.delete(path, headers: headers);
    checkStatusCode(context, response);
    preCallback(response, callback);
    return response;
  }

  static Future<void> login(Function callback, User user) async {
    var body = {};
    body["telephone"] = user.cpf.replaceAll("\t", "");
    body["password"] = user.password.replaceAll("\t", "");
    var headers = {
      "Content-Type" : "application/json; charset=UTF-8"
    };
    dynamic response = await HttpConnection.post("/users/auth/sign_in",
        headers: headers,
        body: json.encode(body)
    );
    posLogin(response, callback);
    return response;
  }

  static Future<void> logout(BuildContext context) async {
    dynamic response = await HttpConnection.post("/users/auth/sign_out");
    checkStatusCode(context, response);
    Connection.accessHeaders = {
      "access-token" : "",
      "client" : "",
      "uid" : ""
    };
    return response;
  }

  static Future<void> preCallback(Response response, Function posCallback) async {

    bool modified = false;
    if (response.headers["access-token"] != null && response.headers["access-token"] != "" && accessHeaders["access-token"] != response.headers["access-token"]) {
      accessHeaders["access-token"] = response.headers["access-token"];
      modified = true;
    }
    if (response.headers["client"] != null && response.headers["client"] != "" && accessHeaders["client"] != response.headers["client"]) {
      accessHeaders["client"] = response.headers["client"];
      modified = true;
    }
    if (response.headers["uid"] != null && response.headers["uid"] != "" && accessHeaders["uid"] != response.headers["uid"]) {
      accessHeaders["uid"] = response.headers["uid"];
      modified = true;
    }

    if (modified) {
      final storage = FlutterSecureStorage();
      storage.deleteAll();
      Map<String, dynamic> loginValues = {
        "user_id" : 1,
        "access-token" : accessHeaders["access-token"],
        "uid" : accessHeaders["uid"],
        "client" : accessHeaders["client"]
      };
      await storage.write(key: "user_login", value: json.encode(loginValues));
    }

    if (posCallback != null) {
      posCallback(response);
    }
  }

  static void posLogin(Response response, Function posCallback) {

    response.headers.forEach((key, value) {
      if (key == "access-token") {
        accessHeaders["access-token"] = value;
      }
      if (key == "client") {
        accessHeaders["client"] = value;
      }
      if (key == "uid") {
        accessHeaders["uid"] = value;
      }
    });

    posCallback(response);

  }

  static Future<bool> checkStatusCode(BuildContext context, Response response, {param: ""}) async {
    print(response.statusCode);
    switch (response.statusCode) {
      case 408:
        if (param == "SocketException") {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text("Verifique sua conexão com a internet."),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      color: MyTheme.THEME_COLOR_1,
                      onPressed: () {
                        Config.guestMode = false;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => PreLoginScreen(check_token: false,)),
                          ModalRoute.withName('/'),
                        );
                      },
                    ),
                  ],
                );
              }
          );
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text("Desculpe, podemos estar em manutenção. Tente novamente em alguns minutos."),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      color: MyTheme.THEME_COLOR_1,
                      onPressed: () {
                        Config.guestMode = false;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => PreLoginScreen(check_token: false,)),
                          ModalRoute.withName('/'),
                        );
                      },
                    ),
                  ],
                );
              }
          );
        }
        break;
      case 401:
        final storage = FlutterSecureStorage();
        await storage.deleteAll();
        Connection.accessHeaders = {
          "access-token" : "",
          "client" : "",
          "uid" : ""
        };
        Config.guestMode = false;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => PreLoginScreen()),
          ModalRoute.withName('/'),
        );
        break;
      default:
        return true;
    }
    return false;
  }

}