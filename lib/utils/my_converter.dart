import 'package:decimal/decimal.dart';

class MyConverter {

  static String sum(v1, v2) {
    Decimal value1 = Decimal.parse(v1.toString());
    Decimal value2 = Decimal.parse(v2.toString());
    return (value1 + value2).toString();
  }

  static String convertPriceUsToBr(dynamic value) {
    String v = value.toString();
    if (v == null) {
      return "0,00";
    }
    if (v.contains(".")) {
      String unit = v.split(".")[0];
      String decimal = v.split(".")[1];
      if (decimal.length == 1) {
        v = unit + "," + decimal + "0";
      } else {
        v = unit + "," + decimal;
      }
    } else if (v.length == 0){
      v = v + "0,00";
    } else {
      v = v + ",00";
    }
    return v;
  }

  static String formatTelephoneNumberToBeautiful(String number) {
    if (number.length != 11) {
      return number;
    }
    return "+ 55 ${number.substring(0, 2)} ${number.substring(2, 3)} ${number.substring(3, 7)} ${number.substring(7, 11)}";
  }

}