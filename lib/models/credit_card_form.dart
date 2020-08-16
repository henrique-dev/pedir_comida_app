import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pedir_comida/config/my_theme.dart';

import 'credit_card_model.dart';
import 'credit_card_widget.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    @required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
    this.errors
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;

  final Map<String, dynamic> errors;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  Color themeColor;
  Map<String, dynamic> errors;

  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;

  final MaskedTextController _cardNumberController =
  MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
  MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
  TextEditingController();
  final TextEditingController _cvvCodeController =
  MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    errors = widget.errors;

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            /*Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.text,
                      controller: _textEditingControllerCardNumber,
                      onChanged: (String s) {
                        validateSpecificField("card_number");
                      },
                      onTap: () {
                        validateSpecificField(_lastElement);
                        _lastElement = "card_number";
                      },
                      decoration: InputDecoration(
                        labelText: "Número do cartão",
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
                      visible: errors["card_number"]["v"],
                      child: Text(errors["card_number"]["d"], style: TextStyle(color: Colors.red)),
                    ),
                  ],
                )
            ),*/
            Container(
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _cardNumberController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  labelText: "Número do cartão",
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
                  hintText: 'xxxx xxxx xxxx xxxx',
                ),
                /*decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card number',
                  hintText: 'xxxx xxxx xxxx xxxx',
                ),*/
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Visibility(
              visible: errors["card_number"]["v"],
              child: Text(errors["card_number"]["d"], style: TextStyle(color: Colors.red)),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _expiryDateController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  labelText: "Vencimento",
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
                  hintText: 'MM/YY'
                ),
                /*decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Expired Date',
                    hintText: 'MM/YY'),*/
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Visibility(
              visible: errors["card_expiration_date"]["v"],
              child: Text(errors["card_expiration_date"]["d"], style: TextStyle(color: Colors.red)),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                focusNode: cvvFocusNode,
                controller: _cvvCodeController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                    labelText: "CVV",
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
                    hintText: 'XXXX',
                ),
                /*decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  hintText: 'XXXX',
                ),*/
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (String text) {
                  setState(() {
                    cvvCode = text;
                  });
                },
              ),
            ),
            Visibility(
              visible: errors["card_cvv"]["v"],
              child: Text(errors["card_cvv"]["d"], style: TextStyle(color: Colors.red)),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: InputDecoration(
                  labelText: "Nome no cartão",
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
                /*decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card Holder',
                ),*/
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
            Visibility(
              visible: errors["card_holder_name"]["v"],
              child: Text(errors["card_holder_name"]["d"], style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}