import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:pedir_comida/config/constants.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/connection/connection.dart';

import '../config.dart';

class AddressScreen extends StatefulWidget {

  int _addressId;

  AddressScreen({address: 0}) {
    this._addressId = address;
  }

  @override
  _AddressScreenState createState() => _AddressScreenState(this._addressId);
}

class _AddressScreenState extends State<AddressScreen> {

  static final bool showErrors = false;

  var errors = {
    "description" : {"d": "forneça uma descrição para o endereço", "v": showErrors, "l" : showErrors, "df": "forneça uma descrição para o endereço"},
    "street" : {"d": "forneça o nome do logradouro", "v": showErrors, "l" : showErrors, "df": "forneça o nome do logradouro"},
    "number" : {"d": "forneça o número da casa", "v": showErrors, "l" : showErrors, "df": "forneça o número da casa"},
    "neighborhood" : {"d": "forneça o bairro", "v": showErrors, "l" : showErrors, "df": "forneça o bairro"},
    "city" : {"d": "forneça a cidade", "v": showErrors, "l" : showErrors, "df": "forneça a cidade"},
    "zipcode" : {"d": "forneça o cep", "v": showErrors, "l" : showErrors, "df": "forneça o cep"}
  };

  TextEditingController _textEditingControllerDescription;
  TextEditingController _textEditingControllerStreet;
  TextEditingController _textEditingControllerNumber;
  String neighborhooDdropdownValue = 'Alvorada';
  TextEditingController _textEditingControllerCity;
  TextEditingController _textEditingControllerZipCode;

  String _lastElement = "";

  int _addressId;
  Map<String, dynamic> _addressData;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  _AddressScreenState(this._addressId);

  @override
  void initState() {
    super.initState();
    if (this._addressId == 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showFormPreAddAddress();
      });
    } else {
      Connection.get("/user/addresses/${this._addressId}.json?", this.context, callback: addressLoaded);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(this._addressId == 0 ? "Novo endereço" : "Editar endereço"),
        backgroundColor: MyTheme.THEME_COLOR_1,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text("Preencha os campos abaixo", textAlign: TextAlign.center,),
              ),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.text,
                              controller: _textEditingControllerDescription,
                              onChanged: (String s) {
                                validateSpecificField("description");
                              },
                              onTap: () {
                                validateSpecificField(_lastElement);
                                _lastElement = "description";
                              },
                              decoration: InputDecoration(
                                labelText: "Descrição",
                                labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1_LIGHT_2),
                                contentPadding: EdgeInsets.only(left: 10, right: 10),
                                hoverColor: Colors.black,
                                filled: true,
                                fillColor: Colors.white,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                                focusedBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                              ),
                            ),
                            Visibility(
                              visible: errors["description"]["v"],
                              child: Text(errors["description"]["d"], style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextField(
                            keyboardType: TextInputType.text,
                            controller: _textEditingControllerStreet,
                            onChanged: (String s) {
                              validateSpecificField("street");
                            },
                            onTap: () {
                              validateSpecificField(_lastElement);
                              _lastElement = "street";
                            },
                            decoration: InputDecoration(
                              labelText: "Logradouro",
                              labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1_LIGHT_2),
                              contentPadding: EdgeInsets.only(left: 10, right: 10),
                              hoverColor: Colors.black,
                              filled: true,
                              fillColor: Colors.white,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black
                                  )
                              ),
                              focusedBorder:  OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black
                                  )
                              ),
                            ),
                          ),
                          Visibility(
                            visible: errors["street"]["v"],
                            child: Text(errors["street"]["d"], style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      )
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.text,
                              controller: _textEditingControllerNumber,
                              onChanged: (String s) {
                                validateSpecificField("number");
                              },
                              onTap: () {
                                validateSpecificField(_lastElement);
                                _lastElement = "number";
                              },
                              decoration: InputDecoration(
                                labelText: "Número",
                                labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1_LIGHT_2),
                                contentPadding: EdgeInsets.only(left: 10, right: 10),
                                hoverColor: Colors.black,
                                filled: true,
                                fillColor: Colors.white,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                                focusedBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                              ),
                            ),
                            Visibility(
                              visible: errors["number"]["v"],
                              child: Text(errors["number"]["d"], style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonHideUnderline(
                              child: Container(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  value: neighborhooDdropdownValue,
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.black),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      neighborhooDdropdownValue = newValue;
                                    });
                                  },
                                  items: Constants.neighborhoods
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: errors["neighborhood"]["v"],
                              child: Text(errors["neighborhood"]["d"], style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.text,
                              controller: _textEditingControllerCity,
                              onChanged: (String s) {
                                validateSpecificField("city");
                              },
                              onTap: () {
                                validateSpecificField(_lastElement);
                                _lastElement = "city";
                              },
                              decoration: InputDecoration(
                                labelText: "Cidade",
                                labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1_LIGHT_2),
                                contentPadding: EdgeInsets.only(left: 10, right: 10),
                                hoverColor: Colors.black,
                                filled: true,
                                fillColor: Colors.white,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                                focusedBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                              ),
                            ),
                            Visibility(
                              visible: errors["city"]["v"],
                              child: Text(errors["city"]["d"], style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.text,
                              controller: _textEditingControllerZipCode,
                              onChanged: (String s) {
                                validateSpecificField("zipcode");
                              },
                              onTap: () {
                                validateSpecificField(_lastElement);
                                _lastElement = "zipcode";
                              },
                              decoration: InputDecoration(
                                labelText: "Cep",
                                labelStyle: TextStyle(color: MyTheme.THEME_COLOR_1_LIGHT_2),
                                contentPadding: EdgeInsets.only(left: 10, right: 10),
                                hoverColor: Colors.black,
                                filled: true,
                                fillColor: Colors.white,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                                focusedBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                              ),
                            ),
                            Visibility(
                              visible: errors["zipcode"]["v"],
                              child: Text(errors["zipcode"]["d"], style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: ButtonTheme(
                        height: 45,
                        child: RaisedButton(
                          onPressed: saveAddress,
                          child: Text("Salvar", style: TextStyle(fontSize: 16),),
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
              ),
            ],
          ),
        ),
      )
    );
  }

  bool validateValues() {
    var result = true;
    setErrorsToDefault();

    errors["description"]["v"] = false;
    errors["street"]["v"] = false;
    errors["number"]["v"] = false;
    errors["neighborhood"]["v"] = false;
    errors["city"]["v"] = false;
    errors["zipcode"]["v"] = false;

    errors.forEach((key, value) {
      if (!validateSpecificField(key)) {
        if (result) {
          result = false;
        }
      }
    });

    setState(() {});
    return result;
  }

  void addressLoaded(Response response) {
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecoded = json.decode(response.body);
      this._textEditingControllerDescription = TextEditingController(text: jsonDecoded["description"]);
      this._textEditingControllerStreet = TextEditingController(text: jsonDecoded["street"]);
      this._textEditingControllerNumber = TextEditingController(text: jsonDecoded["number"]);
      this.neighborhooDdropdownValue = jsonDecoded["neighborhood"];
      this._textEditingControllerCity = TextEditingController(text: jsonDecoded["city"]);
      this._textEditingControllerZipCode = TextEditingController(text: jsonDecoded["zipcode"]);
      setState(() {});
    } else {
      Navigator.pop(context);
    }
  }

  void saveAddress() {
    if (validateValues()) {
      var body = {};
      body["description"] = _textEditingControllerDescription.text.replaceAll("\t", "");
      body["street"] = _textEditingControllerStreet.text.replaceAll("\t", "");
      body["number"] = _textEditingControllerNumber.text.replaceAll("\t", "").replaceAll(" ", "");
      body["neighborhood"] = neighborhooDdropdownValue;
      body["city"] = _textEditingControllerCity.text.replaceAll("\t", "");
      body["zipcode"] = _textEditingControllerZipCode.text.replaceAll("\t", "");

      if (this._addressId != 0) {
        Connection.patch("/user/addresses/${this._addressId}.json", context, callback: saveAddressCallback, body: json.encode(body));
      } else {
        Connection.post("/user/addresses.json", context, callback: saveAddressCallback, body: json.encode(body));
      }
    }
  }

  void saveAddressCallback(Response response) {
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    switch (response.statusCode) {
      case 200 :
      case 201 :
        Navigator.pop(context, "register_success");
        break;
      default :
        Map<String, dynamic> jsonErrors = json.decode(response.body);

        jsonErrors.forEach((key, value) {
          if (errors.containsKey(key)) {
            errors[key]["d"] = value[0].toString();
            errors[key]["v"] = true;
          }
        });
        setState(() {});
        break;
    }
  }

  void setErrorsToDefault() {
    errors["description"]["d"] = errors["description"]["df"];
    errors["street"]["d"] = errors["street"]["df"];
    errors["number"]["d"] = errors["number"]["df"];
    errors["neighborhood"]["d"] = errors["neighborhood"]["df"];
    errors["city"]["d"] = errors["city"]["df"];
    errors["zipcode"]["d"] = errors["zipcode"]["df"];
  }

  bool validateSpecificField(String field) {
    var result = true;

    switch (field) {
      case "description" :
        if (_textEditingControllerDescription.text.length == 0) {
          errors["description"]["v"] = true;
          result = false;
        } else {
          errors["description"]["v"] = false;
        }
        break;
      case "street" :
        if (_textEditingControllerStreet.text.length == 0) {
          errors["street"]["v"] = true;
          result = false;
        } else {
          errors["street"]["v"] = false;
        }
        break;
      case "number" :
        if (_textEditingControllerNumber.text.length == 0) {
          errors["number"]["v"] = true;
          result = false;
        } else {
          errors["number"]["v"] = false;
        }
        break;
      case "city" :
        if (_textEditingControllerCity.text.length == 0) {
          errors["city"]["v"] = true;
          result = false;
        } else {
          errors["city"]["v"] = false;
        }
        break;
      case "zipcode" :
        if (_textEditingControllerZipCode.text.length == 0) {
          errors["zipcode"]["v"] = true;
          result = false;
        } else {
          errors["zipcode"]["v"] = false;
        }
        break;
    }
    setState(() {});
    return result;
  }

  void showFormPreAddAddress() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Usar localização atual?"),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Sim"),
                color: MyTheme.THEME_COLOR_1,
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) {

                        return FutureBuilder(
                          future: getLocal(),
                          builder: (context, snapshot) {

                            Map<String, dynamic> jsonDecoded;

                            switch(snapshot.connectionState) {

                              case ConnectionState.none:
                              // TODO: Handle this case.
                                break;
                              case ConnectionState.waiting:
                                CircularProgressIndicator();
                                break;
                              case ConnectionState.active:
                              // TODO: Handle this case.
                                break;
                              case ConnectionState.done:

                                jsonDecoded = snapshot.data;

                                if (jsonDecoded != null) {

                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text("${jsonDecoded["thoroughfare"]}, ${jsonDecoded["subThoroughfare"]}"),
                                            Text(jsonDecoded["subLocality"]),
                                            Text(jsonDecoded["subAdministrativeArea"]),
                                            Text(jsonDecoded["postalCode"]),
                                          ],
                                        )
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Aplicar"),
                                        color: MyTheme.THEME_COLOR_1,
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          this._textEditingControllerDescription = TextEditingController(text: "");
                                          this._textEditingControllerStreet = TextEditingController(text: jsonDecoded["thoroughfare"]);
                                          this._textEditingControllerNumber = TextEditingController(text: jsonDecoded["subThoroughfare"]);

                                          if (Constants.neighborhoods.contains(jsonDecoded["subLocality"])) {
                                            this.neighborhooDdropdownValue = jsonDecoded["subLocality"];
                                          }

                                          this._textEditingControllerCity = TextEditingController(text: jsonDecoded["subAdministrativeArea"]);
                                          this._textEditingControllerZipCode = TextEditingController(text: jsonDecoded["postalCode"]);
                                          setState(() {});
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Cancelar"),
                                        color: MyTheme.THEME_COLOR_1,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                } else {
                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text("Não foi possível obter os dados da sua localização atual")
                                          ],
                                        )
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Inserir manualmente"),
                                        color: MyTheme.THEME_COLOR_1,
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          //await Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AddressScreen()));
                                          //setState(() {});
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Cancelar"),
                                        color: MyTheme.THEME_COLOR_1,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                }

                                break;
                            }

                            return AlertDialog(
                              content: SingleChildScrollView(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Column(children: [
                                      CircularProgressIndicator(backgroundColor: MyTheme.THEME_COLOR_1_LIGHT_3, valueColor: AlwaysStoppedAnimation(MyTheme.THEME_COLOR_1)),
                                      SizedBox(height: 10,),
                                    ]),
                                  )
                              ),
                            );
                          },
                        );
                      }
                  );
                },
              ),
              FlatButton(
                child: Text("Não"),
                color: MyTheme.THEME_COLOR_1,
                onPressed: () async {
                  Navigator.of(context).pop();
                  //await Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AddressScreen( addressData: Map<String, dynamic>(),)));
                  //setState(() {});
                },
              ),
            ],
          );
        }
    );
  }

  Future<Map<String, dynamic>> getLocal() async {
    Geolocator geolocator = Geolocator();
    Position position = await geolocator.getCurrentPosition();
    List<Placemark> newPlaces = await geolocator.placemarkFromPosition(position);
    if (newPlaces[0] != null) {
      return newPlaces[0].toJson();
    }
    return Placemark().toJson();
  }

}
