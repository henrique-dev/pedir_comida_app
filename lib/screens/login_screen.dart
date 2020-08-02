import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/models/user.dart';
import 'package:pedir_comida/screens/register_screen.dart';

import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _cpfTextEditingController = TextEditingController(text: "01741053200");
  TextEditingController _passwordTextEditingController = TextEditingController(text: "12345678");

  void loginOnPressed() {
    Connection.login(loginCallBack, User(_cpfTextEditingController.text, _passwordTextEditingController.text));
  }

  void loginCallBack(Response response) {
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen()
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Container(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      height: height
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(30),
                        child: Image.asset("images/logo2.png"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("CPF"),
                            TextField(
                              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                              controller: _cpfTextEditingController,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                            ),
                            Text("Senha"),
                            TextField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              controller: _passwordTextEditingController,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            RaisedButton(
                              onPressed: loginOnPressed,
                              child: Text("Entrar"),
                              color: Colors.redAccent,
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Novo usuário?", textAlign: TextAlign.center,),
                            RaisedButton(
                              child: Text("Cadastra-se agora"),
                              onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterScreen()
                                    )
                                );
                                Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(
                                  content: Text("Cadastro realizado com sucesso!!"),
                                ));
                              },
                              color: Colors.black45,
                              textColor: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
          );
        }
      )
    );
  }
}
