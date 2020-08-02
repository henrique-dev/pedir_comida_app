import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pedir_comida/connection/http_connection.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  static final bool showErrors = false;

  var errors = {
    "name" : {"d": "forneça seu nome", "v": showErrors},
    "cpf" : {"d": "forneça seu cpf", "v": showErrors},
    "birthdate" : {"d": "forneça sua data de nascimento", "v": showErrors},
    "height" : {"d": "forneça sua altura ", "v": showErrors},
    "weight" : {"d": "forneça seu peso", "v": showErrors},
    "bloodtype" : {"d": "forneça seu tipo sanguíneo", "v": showErrors},
    "telephone" : {"d": "forneça seu número de celular", "v": showErrors},
    "email" : {"d": "forneça seu e-mail", "v": showErrors},
    "password" : {"d": "forneça uma senha", "v": showErrors},
    "password_confirm" : {"d": "", "v": showErrors}
  };

  TextEditingController _textEditingControllerName = TextEditingController();
  TextEditingController _textEditingControllerCpf = TextEditingController();
  TextEditingController _textEditingControllerBirthDate = TextEditingController();
  TextEditingController _textEditingControllerHeight = TextEditingController();
  TextEditingController _textEditingControllerWeight = TextEditingController();
  TextEditingController _textEditingControllerBloodType = TextEditingController();
  TextEditingController _textEditingControllerTelephone = TextEditingController();
  TextEditingController _textEditingControllerEmail = TextEditingController();
  TextEditingController _textEditingControllerPassword = TextEditingController();
  TextEditingController _textEditingControllerPasswordConfirm = TextEditingController();
  String _genre = "m";
  String _lastElement = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        backgroundColor: Colors.black45,
      ),
      body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Nome completo"),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: _textEditingControllerName,
                        onChanged: (String s) {
                          validateSpecificField("name");
                        },
                        onTap: () {
                          validateSpecificField(_lastElement);
                          _lastElement = "name";
                        },
                      ),
                      Visibility(
                        visible: errors["name"]["v"],
                        child: Text(errors["name"]["d"], style: TextStyle(color: Colors.red)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      Text("CPF"),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _textEditingControllerCpf,
                        onChanged: (String s) {
                          validateSpecificField("cpf");
                        },
                        onTap: () {
                          validateSpecificField(_lastElement);
                          _lastElement = "cpf";
                        },
                      ),
                      Visibility(
                        visible: errors["cpf"]["v"],
                        child: Text(errors["cpf"]["d"], style: TextStyle(color: Colors.red)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      Text("Data de  nascimento"),
                      TextField(
                        keyboardType: TextInputType.datetime,
                        controller: _textEditingControllerBirthDate,
                        onChanged: (String s) {
                          validateSpecificField("birthdate");
                        },
                        onTap: () {
                          validateSpecificField(_lastElement);
                          _lastElement = "birthdate";
                        },
                      ),
                      Visibility(
                        visible: errors["birthdate"]["v"],
                        child: Text(errors["birthdate"]["d"], style: TextStyle(color: Colors.red)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      Text("Gênero"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: (_genre == "m" ? true : false),
                                onChanged: (bool v) {
                                  setState(() {
                                    _genre = "m";
                                  });
                                },
                                activeColor: Colors.redAccent,
                              ),
                              GestureDetector(
                                child: Text("Masculino"),
                                onTap: () {
                                  setState(() {
                                    _genre = "m";
                                  });
                                },
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: (_genre == "f" ? true : false),
                                onChanged: (bool v) {
                                  setState(() {
                                    _genre = "f";
                                  });
                                },
                                activeColor: Colors.redAccent,
                              ),
                              GestureDetector(
                                child: Text("Feminino"),
                                onTap: () {
                                  setState(() {
                                    _genre = "f";
                                  });
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      Text("Altura (metros)"),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _textEditingControllerHeight,
                        onChanged: (String s) {
                          validateSpecificField("height");
                        },
                        onTap: () {
                          validateSpecificField(_lastElement);
                          _lastElement = "height";
                        },
                      ),
                      Visibility(
                        visible: errors["height"]["v"],
                        child: Text(errors["height"]["d"], style: TextStyle(color: Colors.red)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      Text("Peso (quilos)"),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _textEditingControllerWeight,
                        onChanged: (String s) {
                          validateSpecificField("weight");
                        },
                        onTap: () {
                          validateSpecificField(_lastElement);
                          _lastElement = "weight";
                        },
                      ),
                      Visibility(
                        visible: errors["weight"]["v"],
                        child: Text(errors["weight"]["d"], style: TextStyle(color: Colors.red)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      Text("Tipo sanguíneo"),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: _textEditingControllerBloodType,
                        onChanged: (String s) {
                          validateSpecificField("bloodtype");
                        },
                        onTap: () {
                          validateSpecificField(_lastElement);
                          _lastElement = "bloodtype";
                        },
                      ),
                      Visibility(
                        visible: errors["bloodtype"]["v"],
                        child: Text(errors["bloodtype"]["d"], style: TextStyle(color: Colors.red)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      Text("Celular"),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _textEditingControllerTelephone,
                        onChanged: (String s) {
                          validateSpecificField("telephone");
                        },
                        onTap: () {
                          validateSpecificField(_lastElement);
                          _lastElement = "telephone";
                        },
                      ),
                      Visibility(
                        visible: errors["telephone"]["v"],
                        child: Text(errors["telephone"]["d"], style: TextStyle(color: Colors.red)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      Text("E-mail"),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _textEditingControllerEmail,
                        onChanged: (String s) {
                          validateSpecificField("email");
                        },
                        onTap: () {
                          validateSpecificField(_lastElement);
                          _lastElement = "email";
                        },
                      ),
                      Visibility(
                        visible: errors["email"]["v"],
                        child: Text(errors["email"]["d"], style: TextStyle(color: Colors.red)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                      ),
                      Text("Senha"),
                      TextField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _textEditingControllerPassword,
                        obscureText: true,
                        onChanged: (String s) {
                          validateSpecificField("password");
                        },
                        onTap: () {
                          validateSpecificField(_lastElement);
                          _lastElement = "password";
                        },
                      ),
                      Visibility(
                        visible: errors["password"]["v"],
                        child: Text(errors["password"]["d"], style: TextStyle(color: Colors.red)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      Text("Repita a senha"),
                      TextField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _textEditingControllerPasswordConfirm,
                        obscureText: true,
                        onChanged: (String s) {
                          validateSpecificField("password_confirm");
                        },
                        onTap: () {
                          validateSpecificField(_lastElement);
                          _lastElement = "password_confirm";
                        },
                      ),
                      Visibility(
                        visible: errors["password_confirm"]["v"],
                        child: Text(errors["password_confirm"]["d"], style: TextStyle(color: Colors.red)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      RaisedButton(
                        onPressed: registerUser,
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        child: Text("Cadastrar"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  void registerUser() {
    if (validateValues()) {
      HttpConnection.get("medic_profiles", callBack: registerUserCallBack).then((value) => (v) {
        print ("EOQ: " + v);
      });
    }
  }

  void registerUserCallBack(int statusCode, dynamic json) {
    switch (statusCode) {
      case 200 :
        Navigator.pop(context, "register_success");
        break;
      default :
        break;
    }
  }

  bool validateValues() {
    var result = true;
    errors["name"]["v"] = false;
    errors["cpf"]["v"] = false;
    errors["birthdate"]["v"] = false;
    errors["height"]["v"] = false;
    errors["weight"]["v"] = false;
    errors["bloodtype"]["v"] = false;
    errors["telephone"]["v"] = false;
    errors["email"]["v"] = false;
    errors["password"]["v"] = false;
    errors["password_confirm"]["v"] = false;

    errors.forEach((key, value) {
      validateSpecificField(key);
    });

    setState(() {});
    return result;
  }

  bool validateSpecificField(String field) {
    var result = true;

    switch (field) {
      case "name" :
        if (_textEditingControllerName.text.length == 0) {
          errors["name"]["v"] = true;
          result = false;
        } else {
          errors["name"]["v"] = false;
        }
        break;
      case "cpf" :
        if (_textEditingControllerCpf.text.length == 0) {
          errors["cpf"]["v"] = true;
          result = false;
        } else {
          errors["cpf"]["v"] = false;
        }
        break;
      case "birthdate" :
        if (_textEditingControllerBirthDate.text.length == 0) {
          errors["birthdate"]["v"] = true;
          result = false;
        } else {
          errors["birthdate"]["v"] = false;
        }
        break;
      case "height" :
        if (_textEditingControllerHeight.text.length == 0) {
          errors["height"]["v"] = true;
          result = false;
        } else {
          errors["height"]["v"] = false;
        }
        break;
      case "weight" :
        if (_textEditingControllerWeight.text.length == 0) {
          errors["weight"]["v"] = true;
          result = false;
        } else {
          errors["weight"]["v"] = false;
        }
        break;
      case "bloodtype" :
        if (_textEditingControllerBloodType.text.length == 0) {
          errors["bloodtype"]["v"] = true;
          result = false;
        } else {
          errors["bloodtype"]["v"] = false;
        }
        break;
      case "telephone" :
        if (_textEditingControllerTelephone.text.length == 0) {
          errors["telephone"]["v"] = true;
          result = false;
        } else {
          errors["telephone"]["v"] = false;
        }
        break;
      case "email" :
        if (_textEditingControllerEmail.text.length == 0) {
          errors["email"]["v"] = true;
          result = false;
        } else {
          errors["email"]["v"] = false;
        }
        break;
      case "password" :
        if (_textEditingControllerPassword.text.length == 0) {
          errors["password"]["v"] = true;
          result = false;
        } else {
          errors["password"]["v"] = false;
        }
        break;
      case "password_confirm" :
        if (_textEditingControllerPasswordConfirm.text.length == 0) {
          errors["password_confirm"]["v"] = true;
          result = false;
        } else {
          errors["password_confirm"]["v"] = false;
        }
        break;
    }
    setState(() {});
    return result;
  }
}
