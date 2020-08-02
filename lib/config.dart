import 'package:flutter/cupertino.dart';

abstract class Config {

  static String parseDateUsToBr(String date) {
    List tmp = date.split("-");
    return "${tmp[2]}/${tmp[1]}/${tmp[0]}";
  }

}