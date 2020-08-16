import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pedir_comida/config/constants.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/models/user.dart';
import 'package:pedir_comida/utils/my_converter.dart';

import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {

  static const int TELEPHONE_FORM = 0;
  static const int PASSWORD_FORM = 1;
  static const int LOADING_FORM = 2;
  static const int REGISTER_FORM = 3;
  static const int INSERT_TOKEN_FORM = 4;

  TextEditingController _nameTextEditingController = TextEditingController(text: "Paulo Henrique");
  TextEditingController _telephoneTextEditingController = TextEditingController(text: "96991100443");
  TextEditingController _passwordTextEditingController = TextEditingController(text: "123456");
  TextEditingController _passwordConfirmTextEditingController = TextEditingController(text: "123456");
  TextEditingController _tokenTextEditingController = TextEditingController(text: "123456");

  int _currentForm = 0;
  int _nextForm = 0;
  int _nextFormPosLoading = 0;

  double _imageHeight = 250;

  bool _telephoneFormVisible = true;
  bool _passwordFormVisible = false;
  bool _registerFormVisible = false;
  bool _insertTokenFormVisible = false;

  bool _wrongPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.THEME_COLOR_1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(50),
                child: AnimatedSize(
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 250),
                  vsync: this,
                  child: Image.asset("assets/images/splash_logo2.png", height: _imageHeight,),
                ),
              ),
              getForm()
            ],
          ),
        )
      )
    );
  }

  getTelephoneForm() {
    return AnimatedOpacity(
      opacity: _telephoneFormVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 250),
      onEnd: () {
        _currentForm = _nextForm;
        setState(() {});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              "Insira seu número de telefone", textAlign: TextAlign.center,),
          ),
          TextField(
            keyboardType: TextInputType.phone,
            cursorColor: MyTheme.THEME_COLOR_1,
            controller: _telephoneTextEditingController,
            inputFormatters: [
              MaskTextInputFormatter(
                  mask: "## # #### ####", filter: { "#": RegExp(r'[0-9]')}
              )
            ],
            decoration: InputDecoration(
              labelText: "Telefone",
              labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              hoverColor: Colors.red,
              filled: true,
              fillColor: Colors.white,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
              prefix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_android),
                  Text(" +55 ")
                ],
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: MyTheme.THEME_COLOR_1
                  )
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: MyTheme.THEME_COLOR_1
                  )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ButtonTheme(
              height: 50,
              child: RaisedButton(
                onPressed: () async {
                  _nextFormPosLoading = await checkTelephone();
                  _nextForm = LOADING_FORM;
                  _telephoneFormVisible = false;
                  setState(() {});
                },
                child: Text("Prosseguir", style: TextStyle(fontSize: 16),),
                color: MyTheme.THEME_COLOR_1,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black12)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getPasswordForm() {
    return AnimatedOpacity(
      opacity: _passwordFormVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              "Insira sua senha", textAlign: TextAlign.center,),
          ),
          TextField(
            keyboardType: TextInputType.phone,
            cursorColor: MyTheme.THEME_COLOR_1,
            controller: _passwordTextEditingController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Senha",
              labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              hoverColor: Colors.red,
              filled: true,
              fillColor: Colors.white,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: MyTheme.THEME_COLOR_1
                  )
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: MyTheme.THEME_COLOR_1
                  )
              ),
            ),
          ),
          Visibility(
            visible: _wrongPassword,
            child: Center(
              child: Text("Senha inválida", style: TextStyle(color: Colors.red)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ButtonTheme(
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  passwordFormNext();
                },
                child: Text("Prosseguir", style: TextStyle(fontSize: 16),),
                color: MyTheme.THEME_COLOR_1,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black12)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getRegisterForm() {
    return AnimatedOpacity(
      opacity: _registerFormVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 250),
      onEnd: () {
        _imageHeight = 150;
        setState(() {
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5, right: 20, left: 20),
            child: Text(
              "Preencha os campos abaixo para realizar seu cadastro", textAlign: TextAlign.center,),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: TextField(
              keyboardType: TextInputType.phone,
              cursorColor: MyTheme.THEME_COLOR_1,
              controller: _telephoneTextEditingController,
              inputFormatters: [
                MaskTextInputFormatter(
                    mask: "## # #### ####", filter: { "#": RegExp(r'[0-9]')}
                )
              ],
              decoration: InputDecoration(
                labelText: "Telefone",
                labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hoverColor: Colors.red,
                filled: true,
                fillColor: Colors.white,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.phone_android),
                    Text(" +55 ")
                  ],
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: MyTheme.THEME_COLOR_1
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: MyTheme.THEME_COLOR_1
                    )
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: TextField(
              keyboardType: TextInputType.phone,
              cursorColor: MyTheme.THEME_COLOR_1,
              controller: _nameTextEditingController,
              decoration: InputDecoration(
                labelText: "Nome",
                labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hoverColor: Colors.red,
                filled: true,
                fillColor: Colors.white,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: MyTheme.THEME_COLOR_1
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: MyTheme.THEME_COLOR_1
                    )
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: TextField(
              keyboardType: TextInputType.text,
              cursorColor: MyTheme.THEME_COLOR_1,
              controller: _passwordTextEditingController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hoverColor: Colors.red,
                filled: true,
                fillColor: Colors.white,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: MyTheme.THEME_COLOR_1
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: MyTheme.THEME_COLOR_1
                    )
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: TextField(
              keyboardType: TextInputType.text,
              cursorColor: MyTheme.THEME_COLOR_1,
              controller: _passwordConfirmTextEditingController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirme a senha",
                labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hoverColor: Colors.red,
                filled: true,
                fillColor: Colors.white,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: MyTheme.THEME_COLOR_1
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: MyTheme.THEME_COLOR_1
                    )
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ButtonTheme(
              height: 50,
              child: RaisedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text("Será enviado um sms com um código de ativação para este número", textAlign: TextAlign.center,),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(MyConverter.formatTelephoneNumberToBeautiful(_telephoneTextEditingController.text), textAlign: TextAlign.center,),
                                ),
                                Text("O número do telefone está correto?", textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                          actions: [
                            FlatButton(
                              child: Text("Sim"),
                              color: MyTheme.THEME_COLOR_1,
                              onPressed: () async {
                                Navigator.of(context).pop();
                                registerFormNext();
                              },
                            ),
                            FlatButton(
                              child: Text("Não"),
                              color: MyTheme.THEME_COLOR_1,
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }
                  );
                },
                child: Text("Prosseguir", style: TextStyle(fontSize: 16),),
                color: MyTheme.THEME_COLOR_1,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black12)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getInsertTokenForm() {
    return AnimatedOpacity(
      opacity: _insertTokenFormVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              "Insira o código enviado no sms", textAlign: TextAlign.center,),
          ),
          TextField(
            keyboardType: TextInputType.phone,
            cursorColor: MyTheme.THEME_COLOR_1,
            controller: _tokenTextEditingController,
            decoration: InputDecoration(
              labelText: "Código",
              labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              hoverColor: Colors.red,
              filled: true,
              fillColor: Colors.white,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: MyTheme.THEME_COLOR_1
                  )
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: MyTheme.THEME_COLOR_1
                  )
              ),
            ),
          ),
          Visibility(
            visible: _wrongPassword,
            child: Center(
              child: Text("Código inválido", style: TextStyle(color: Colors.red)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ButtonTheme(
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  insertTokenFormNext();
                },
                child: Text("Prosseguir", style: TextStyle(fontSize: 16),),
                color: MyTheme.THEME_COLOR_1,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black12)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getWaitingForm() {
    return FutureBuilder(
      future: Future.delayed(
        const Duration(seconds: 2), () {
        _currentForm = _nextFormPosLoading;
        Future.delayed(
          const Duration(milliseconds: 250), () {
            switch(_nextFormPosLoading) {
              case PASSWORD_FORM:
                _passwordFormVisible = true;
                setState(() {});
                break;
              case REGISTER_FORM:
                _registerFormVisible = true;
                setState(() {});
                break;
              case INSERT_TOKEN_FORM:
                _insertTokenFormVisible = true;
                setState(() {});
                break;
            }
        });
        setState(() {});
      }),
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(child: Text("Verificando"),),
            ),
            Center(child: CircularProgressIndicator(backgroundColor: MyTheme.THEME_COLOR_1_LIGHT_3, valueColor: AlwaysStoppedAnimation(MyTheme.THEME_COLOR_1))),
            Center(),
          ]
        );
      },
    );
  }

  Future<int> checkTelephone() async {
    var body = {};
    body["register"] = {};
    body["register"]["telephone"] = _telephoneTextEditingController.text.replaceAll("\t", "");;
    Response response = await Connection.post("/user/register/check_telephone", context, body: json.encode(body));
    if (response.statusCode == 200) {
      Map <String, dynamic> jsonDecoded = json.decode(response.body);
      if (jsonDecoded["status"] != null) {
        switch(jsonDecoded["status"]["control"]) {
          case "exists" :
            if (jsonDecoded["status"]["can_login"]) {
              return PASSWORD_FORM;
            }
            break;
          case "not_exists" :
            return REGISTER_FORM;
            break;
        }
      }
    }
    _telephoneFormVisible = true;
    return 0;
  }

  Future<void> loginCallBack(Response response) async {
    if (response.statusCode == 200) {

      Map<String, dynamic> jsonDecoded = json.decode(response.body);

      Constants.userId = jsonDecoded["data"]["id"];

      final storage = FlutterSecureStorage();
      storage.deleteAll();
      Map<String, dynamic> loginValues = {
        "user_id" : jsonDecoded["data"]["id"],
        "access-token" : response.headers["access-token"],
        "uid" : response.headers["uid"],
        "client" : response.headers["client"]
      };
      await storage.write(key: "user_login", value: json.encode(loginValues));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
        ModalRoute.withName('/'),
      );
    } else if (response.statusCode == 401) {
      setState(() {
        _wrongPassword = true;
      });
    }
  }

  Widget getForm() {
    switch (_currentForm) {
      case 0: return getTelephoneForm();
      case 1: return getPasswordForm();
      case 2: return getWaitingForm();
      case 3: return getRegisterForm();
      case 4: return getInsertTokenForm();
    }
  }

  void passwordFormNext() {
    Connection.login(loginCallBack, User(_telephoneTextEditingController.text, _passwordTextEditingController.text));
  }

  Future<void> registerFormNext() async {
    var body = {};
    body = {};
    body["telephone"] = _telephoneTextEditingController.text.replaceAll("\t", "");
    body["name"] = _nameTextEditingController.text.replaceAll("\t", "");
    body["password"] = _passwordTextEditingController.text.replaceAll("\t", "");
    body["password_confirmation"] = _passwordConfirmTextEditingController.text.replaceAll("\t", "");

    Response response = await Connection.post("/users/auth", context, body: json.encode(body));

    if (response.statusCode == 200) {
      Map <String, dynamic> jsonDecoded = json.decode(response.body);
      if (jsonDecoded["status"] == "success") {
        _nextForm = LOADING_FORM;
        _currentForm = _nextForm;
        _nextFormPosLoading = INSERT_TOKEN_FORM;
        _registerFormVisible = false;
        _imageHeight = 250;
        setState(() {});
      } else {

      }
    }
  }

  Future<void> insertTokenFormNext() async {
    var body = {};
    body = {};
    body["confirmation_token"] = _tokenTextEditingController.text.replaceAll("\t", "");
    body["telephone"] = _telephoneTextEditingController.text.replaceAll("\t", "");

    Response response = await Connection.post("/user/register/confirm_token", context, body: json.encode(body));

    if (response.statusCode == 200) {
      Map <String, dynamic> jsonDecoded = json.decode(response.body);
      if (jsonDecoded["status"] == "success") {
        passwordFormNext();
      } else {

      }
    }
  }

}