import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pedir_comida/connection/connection.dart';

import '../config.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus dados"),
        backgroundColor: Colors.black45
      ),
      body: Container(
        child: FutureBuilder<dynamic>(
          future: Connection.get("patient/patient_profiles/0.json", context, callback: null),
          builder: (context, snapshot) {

            Map<String, dynamic> jsonDecoded;

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
                  dynamic body = json.decode(response.body);

                  if (body is Map<String, dynamic>) {
                    jsonDecoded = json.decode(response.body);
                  } else {
                    //Connection.checkResponse(response, reloadCallback);
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Nome completo", style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 15
                            ),),
                            Text(jsonDecoded["name"], style: TextStyle(
                                fontSize: 15
                            ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Email", style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15
                            ),),
                            Text(jsonDecoded["email"], style: TextStyle(
                                fontSize: 15
                            ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Gênero", style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15
                            ),),
                            Text(jsonDecoded["genre"] == "m" ? "Masculino" : "Feminino", style: TextStyle(
                                fontSize: 15
                            ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Data de nascimento", style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15
                            ),),
                            Text(Config.parseDateUsToBr(jsonDecoded["birth_date"]), style: TextStyle(
                                fontSize: 15
                            ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Altura", style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15
                            ),),
                            Text(jsonDecoded["height"].toString(), style: TextStyle(
                                fontSize: 15
                            ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Peso", style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15
                            ),),
                            Text(jsonDecoded["weight"].toString(), style: TextStyle(
                                fontSize: 15
                            ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tipo sanguíneo", style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15
                            ),),
                            Text(jsonDecoded["bloodtype"].toString(), style: TextStyle(
                                fontSize: 15
                            ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Telefone", style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15
                            ),),
                            Text(jsonDecoded["telephone"].toString(), style: TextStyle(
                                fontSize: 15
                            ),),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                break;
            }
            return Center(
              child: Text(""),
            );
          },
        ),
      ),
    );
  }
}
