import 'package:http/http.dart' as http;

class HttpConnection {

  static final String host = "http://192.168.1.128:3000";
  //static final String host = "http://headred.com.br";
  static final String hostWs = "ws://192.168.1.128:3000/cable";
  //static final String hostWs = "ws://headred.com.br/cable";

  static Future<dynamic> get(String path, {Map<String, String> headers}) async {
    String url = host + path;
    dynamic response = await http.get(url, headers: headers);
    return response;
  }

  static Future<dynamic> post(String path, {Map<String, String> headers, dynamic body}) async {
    String url = host + path;
    dynamic response = await http.post(
      url,
      headers: headers,
      body: body
    );
    return response;
  }

  static Future<dynamic> patch(String path, {Map<String, String> headers, dynamic body}) async {
    String url = host + path;
    dynamic response = await http.patch(
        url,
        headers: headers,
        body: body
    );
    return response;
  }

  static Future<dynamic> delete(String path, {Map<String, String> headers}) async {
    String url = host + path;
    dynamic response = await http.delete(
        url,
        headers: headers
    );
    return response;
  }

}