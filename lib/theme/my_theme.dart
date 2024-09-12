import 'package:flutter/material.dart';
import 'package:password_manager/theme/my_colors.dart';

class MyTheme {
  static ThemeData lightMode = ThemeData(
    useMaterial3: true,
    fontFamily: 'Montserrat',
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: MyColors.greenColor,
      onPrimary: MyColors.whiteColor,
      secondary: MyColors.lightColor,
      inversePrimary: MyColors.darkColor,
    ),
  );

  static ThemeData darkMode = ThemeData(
    useMaterial3: true,
    fontFamily: 'Montserrat',
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: MyColors.greenColor,
      onPrimary: MyColors.blackColor,
      secondary: MyColors.darkColor,
      inversePrimary: MyColors.lightColor,
    ),
  );
}
