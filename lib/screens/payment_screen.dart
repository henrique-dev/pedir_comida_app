import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pedir_comida/config/constants.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/models/credit_card_form.dart';
import 'package:pedir_comida/models/credit_card_model.dart';
import 'package:pedir_comida/models/credit_card_widget.dart';

import '../config.dart';

class PaymentScreen extends StatefulWidget {

  int _paymentId;

  PaymentScreen({payment: 0}) {
    this._paymentId = payment;
  }

  @override
  _PaymentScreenState createState() => _PaymentScreenState(this._paymentId);
}

class _PaymentScreenState extends State<PaymentScreen> {

  static final bool showErrors = false;

  var errors = {
    "card_number" : {"d": "forneça o número do cartão", "v": showErrors, "l" : showErrors, "df": "forneça o número do cartão"},
    "card_expiration_date" : {"d": "forneça o vencimento do cartão", "v": showErrors, "l" : showErrors, "df": "forneça o vencimento do cartão"},
    "card_holder_name" : {"d": "forneça o nome do proprietário do cartão", "v": showErrors, "l" : showErrors, "df": "forneça o nome do proprietário do cartão"},
    "card_cvv" : {"d": "forneça o código de seguração do cartão", "v": showErrors, "l" : showErrors, "df": "forneça o código de seguração do cartão"},
    "payment_type" : {"d": "forneça o tipo de pagamento", "v": showErrors, "l" : showErrors, "df": "forneça o tipo de pagamento"}
  };

  String cardNumber = "4539 3070 7049 4118";
  String expiryDate = "03/22";
  String cardHolderName = "PAULO H G BACELAR";
  String cvvCode = "542";
  String brand;
  bool isCvvFocused = false;
  int PaymentTypeDropdownValue = 0;

  String _lastElement = "";

  int _paymentId;

  _PaymentScreenState(this._paymentId);

  @override
  void initState() {
    super.initState();
    if (this._paymentId != 0) {
      Connection.get("/user/pagarmes/${this._paymentId}.json?", this.context, callback: cardLoaded);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(this._paymentId == 0 ? "Nova forma de pagamento" : "Editar forma de pagamento"),
        backgroundColor: MyTheme.THEME_COLOR_1,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              this._paymentId == 0 ? Padding(
                padding: EdgeInsets.all(10),
                child: Text("Preencha os campos abaixo", textAlign: TextAlign.center,),
              ) : Container(),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CreditCardWidget(
                      brand: this.brand,
                      cardNumber: this.cardNumber,
                      expiryDate: this.expiryDate,
                      cardHolderName: this.cardHolderName,
                      cvvCode: this.cvvCode,
                      showBackView: isCvvFocused, //t// rue when you want to show cvv(back) view
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
                                child: DropdownButton<int>(
                                  value: PaymentTypeDropdownValue,
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.black),
                                  onChanged: (int newValue) {
                                    if (this._paymentId == 0) {
                                      setState(() {
                                        PaymentTypeDropdownValue = newValue;
                                      });
                                    }
                                  },
                                  items: Constants.paymentTypes.keys
                                      .map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(Constants.paymentTypes[value]),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: errors["payment_type"]["v"],
                              child: Text(errors["payment_type"]["d"], style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        )
                    ),
                    this._paymentId == 0 ? CreditCardForm(
                      onlyRead: this._paymentId != 0 ? true : false,
                      errors: errors,
                      onCreditCardModelChange: (CreditCardModel creditCardModel) {
                        setState(() {
                          cardNumber = creditCardModel.cardNumber;
                          expiryDate = creditCardModel.expiryDate;
                          cardHolderName = creditCardModel.cardHolderName;
                          cvvCode = creditCardModel.cvvCode;
                          isCvvFocused = creditCardModel.isCvvFocused;
                        });
                      },
                    ) : Container(),
                    this._paymentId == 0 ? Padding(
                      padding: EdgeInsets.all(10),
                      child: ButtonTheme(
                        height: 45,
                        child: RaisedButton(
                          onPressed: saveCard,
                          child: Text("Salvar", style: TextStyle(fontSize: 16),),
                          color: MyTheme.THEME_COLOR_1,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.black12)
                          ),
                        ),
                      ),
                    ) : Padding(
                      padding: EdgeInsets.all(10),
                      child: ButtonTheme(
                        height: 45,
                        child: RaisedButton(
                          onPressed: removeCard,
                          child: Text("Remover", style: TextStyle(fontSize: 16),),
                          color: Colors.redAccent,
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

    errors["card_number"]["v"] = false;
    errors["card_expiration_date"]["v"] = false;
    errors["card_holder_name"]["v"] = false;
    errors["payment_type"]["v"] = false;
    errors["card_cvv"]["v"] = false;

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

  void cardLoaded(Response response) {
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecoded = json.decode(response.body);
      cardNumber = jsonDecoded["description"];
      cardHolderName = jsonDecoded["holder_name"];
      brand = jsonDecoded["brand"];
      setState(() {});
    } else {
      Navigator.pop(context);
    }
  }

  void saveCard() {
    if (validateValues()) {
      var body = {};
      body["card_number"] = cardNumber;
      body["card_expiration_date"] = expiryDate;
      body["card_holder_name"] = cardHolderName;
      body["payment_center_type"] = PaymentTypeDropdownValue;
      body["card_cvv"] = cvvCode;

      if (this._paymentId != 0) {
        Connection.patch("/user/addresses/${this._paymentId}.json", context, callback: saveCardCallback, body: json.encode(body));
      } else {
        Connection.post("/user/pagarmes.json", context, callback: saveCardCallback, body: json.encode(body));
      }
    }
  }

  void removeCard() {
    var body = {};
    body["id"] = this._paymentId;
    Connection.delete("/user/pagarmes/${this._paymentId}.json", context, callback: removeCardCallback, body: json.encode(body));
  }

  void saveCardCallback(Response response) {
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

  void removeCardCallback(Response response) {
    switch (response.statusCode) {
      case 200 :
      case 201 :
        Navigator.pop(context, "register_success");
        break;
      default :
        setState(() {});
        break;
    }
  }

  void setErrorsToDefault() {
    errors["card_number"]["d"] = errors["card_number"]["df"];
    errors["card_expiration_date"]["d"] = errors["card_expiration_date"]["df"];
    errors["card_holder_name"]["d"] = errors["card_holder_name"]["df"];
    errors["payment_type"]["d"] = errors["payment_type"]["df"];
    errors["card_cvv"]["d"] = errors["card_cvv"]["df"];
  }

  bool validateSpecificField(String field) {
    var result = true;

    switch (field) {
      case "card_number" :
        if (cardNumber.length == 0) {
          errors["card_number"]["v"] = true;
          result = false;
        } else {
          errors["card_number"]["v"] = false;
        }
        break;
      case "card_expiration_date" :
        if (expiryDate.length == 0) {
          errors["card_expiration_date"]["v"] = true;
          result = false;
        } else {
          errors["card_expiration_date"]["v"] = false;
        }
        break;
      case "card_holder_name" :
        if (cardHolderName.length == 0) {
          errors["card_holder_name"]["v"] = true;
          result = false;
        } else {
          errors["card_holder_name"]["v"] = false;
        }
        break;
      case "card_cvv" :
        if (cvvCode.length == 0) {
          errors["card_cvv"]["v"] = true;
          result = false;
        } else {
          errors["card_cvv"]["v"] = false;
        }
        break;
    }

    setState(() {});
    return result;
  }

}
