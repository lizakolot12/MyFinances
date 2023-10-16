import 'package:flutter/material.dart';

extension SpecialTextExtensions on ThemeData {
  TextStyle get mySpecialTextStyle {
    return const TextStyle(
      color: Colors.redAccent,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(1.0, 1.0),
          blurRadius: 3.0,
          color: Color.fromARGB(255, 243, 224, 224),
        )
      ],
    );
  }
}
