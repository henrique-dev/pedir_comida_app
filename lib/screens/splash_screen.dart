import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/config/transition.dart';
import 'package:pedir_comida/screens/main_screen.dart';

import 'pre_login_screen.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
    Future.delayed(Duration(seconds: 4)).then((_){
      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: PreLoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.THEME_COLOR_1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(125),
            child: Image.asset("assets/images/splash_logo.png"),
          )
        ],
      ),
    );
  }
}
