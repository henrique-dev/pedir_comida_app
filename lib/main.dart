import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pedir_comida/screens/splash_screen.dart';

void main () {

  runApp(
    MaterialApp(
      home: SplashScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.getTextTheme("Cabin")
      ),
    )
  );
}