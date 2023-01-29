import 'package:flutter/material.dart';

const key = "TmVBGchzcvTktNiQWjgeAPeDd9Ly6Qi3KzIsZaAK43crXYtOXRWe3Rbr";

const String handlee='Handlee-Regular';
const String montserrat ='Montserrat';
const String notFoundIllustration = 'assets/not_found.svg';

const Color creamWhite = Color.fromARGB(255,236 ,236, 236);
const Color black = Colors.black;

final theme = ThemeData.light().copyWith(
  primaryColor: Colors.red,
  colorScheme: const ColorScheme.light().copyWith(
    primary: Colors.pink,
    secondary: black
  )
);