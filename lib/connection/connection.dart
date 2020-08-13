import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  static Future<dynamic> patch(String path, {Function callback,
    Map<String, String> headers, dynamic body}) async {
    if (headers == null) {
      headers = {
        "Content-Type" : "application/json; charset=UTF-8"
      };
    }
    headers.addAll(accessHeaders);
    return HttpConnection.patch(path, callBack: preCallback, posCallBack: callback, headers: headers, body: body);
  }

  static Future<dynamic> delete(String path, {Function callback,
    Map<String, String> headers, dynamic body}) async {
    if (headers == null) {
      headers = {
        "Content-Type" : "application/json; charset=UTF-8"
      };
    }
    headers.addAll(accessHeaders);
    return HttpConnection.delete(path, callBack: preCallback, posCallBack: callback, headers: headers);
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
    body["telephone"] = user.cpf.replaceAll("\t", "");
    body["password"] = user.password.replaceAll("\t", "");
    var headers = {
      "Content-Type" : "application/json; charset=UTF-8"
    };
    HttpConnection.post("/users/auth/sign_in",
        callBack: posLogin,
        posCallBack: callback,
        headers: headers,
        body: json.encode(body)
    );
  }

  static Future<void> logout(Function callback) async {
    return HttpConnection.delete("users/sign_out", callBack: preCallback, posCallBack: callback);
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

}