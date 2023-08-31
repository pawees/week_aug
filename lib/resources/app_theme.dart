import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:equatable/equatable.dart';

class MyAppTheme extends Equatable {

  MyAppTheme.themePremium()  : _theme = ThemeData(backgroundColor: Colors.white, colorScheme: premiumColorScheme);

  MyAppTheme.themeDefault()  : _theme = ThemeData(backgroundColor: Colors.white, colorScheme: defaultColorScheme);


  final ThemeData _theme;

  ThemeData use(){
    return _theme;
  }

  //
  // MyAppTheme.themeDefault({theme: ThemeData(
  //     backgroundColor: Colors.white, colorScheme: defaultColorScheme);}
  //     );
  // MyAppTheme.themePremium({});
  // static ThemeData themeDefault = ThemeData(
  //     backgroundColor: Colors.white,
  //     colorScheme: defaultColorScheme,
  //
  //
  // );
  //
  // static ThemeData themePremium = ThemeData(
  //     backgroundColor: Colors.white,
  //     colorScheme: premiumColorScheme,
  //
  // );
  //
  @override
  List<Object?> get props => [_theme];


}
