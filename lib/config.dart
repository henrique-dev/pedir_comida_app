import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'config/my_theme.dart';

abstract class Config {

  static bool guestMode = false;

  static String parseDateUsToBr(String date) {
    if (date == null) return "";
    List tmp = date.split("-");
    return "${tmp[2]}/${tmp[1]}/${tmp[0]}";
  }

  static String parseDateBrToUs(String date) {
    if (date == null) return "";
    List tmp = date.split("/");
    return "${tmp[2]}-${tmp[1]}-${tmp[0]}";
  }

}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String msg) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(backgroundColor: MyTheme.THEME_COLOR_1_LIGHT_3, valueColor: AlwaysStoppedAnimation(MyTheme.THEME_COLOR_1)),
                        SizedBox(height: 10,),
                        Text(msg,style: TextStyle(color: Colors.black45),)
                      ]),
                    )
                  ]));
        });
  }
}