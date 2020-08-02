import 'dart:convert';

import 'package:http/http.dart';
import 'package:pedir_comida/models/user.dart';

import 'http_connection.dart';

class Connection {

  static var accessHeaders = {
    "access-token" : "",
    "client" : "",
    "uid" : ""
  };

  static Future<dynamic> get(String path, {Function callback,
    Map<String, String> headers}) async {
    if (headers == null) {
      headers = {
        "Content-Type" : "application/json; charset=UTF-8"
      };
    }
    headers.addAll(accessHeaders);
    return HttpConnection.get(path, callBack: preCallback, posCallBack: callback, headers: headers);
  }

  static Future<dynamic> post(String path, {Function callback,
    Map<String, String> headers, dynamic body}) async {
    if (headers == null) {
      headers = {
        "Content-Type" : "application/json; charset=UTF-8"
      };
    }
    headers.addAll(accessHeaders);
    return HttpConnection.post(path, callBack: preCallback, posCallBack: callback, headers: headers, body: body);
  }

  static Response checkResponse(Response response, Function callback) {
    switch (response.statusCode) {
      case 401:
        logout(callback);
        break;
    }
    return response;
  }

  static void login(Function callback, User user) {
    var body = {};
    body["cpf"] = user.cpf.replaceAll("\t", "");
    body["password"] = user.password.replaceAll("\t", "");
    var headers = {
      "Content-Type" : "application/json; charset=UTF-8"
    };
    HttpConnection.post("patients/auth/sign_in",
        callBack: posLogin,
        posCallBack: callback,
        headers: headers,
        body: json.encode(body)
    );
  }

  static Future<void> logout(Function callback) async {
    return HttpConnection.delete("patients/sign_out", callBack: preCallback, posCallBack: callback);
  }

  static void preCallback(Response response, Function posCallback) {
    if (response.headers["access-token"] != null && response.headers["access-token"] != "") {
      accessHeaders["access-token"] = response.headers["access-token"];
    }
    if (response.headers["client"] != null && response.headers["client"] != "") {
      accessHeaders["client"] = response.headers["client"];
    }
    if (response.headers["uid"] != null && response.headers["uid"] != "") {
      accessHeaders["uid"] = response.headers["uid"];
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

}