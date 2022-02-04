// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ChatThemeData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor, Brightness.light);
  static ThemeData darkThemeData =
      themeData(darkColorScheme, _darkFocusColor, Brightness.dark);

  static ThemeData themeData(
      ColorScheme colorScheme, Color focusColor, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      primaryColor: colorScheme.primary,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onBackground),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.transparent),
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFF7371fc),
    primaryVariant: Color(0xFFc19bff),
    secondary: Color(0xff46494c),
    secondaryVariant: Color(0xff018786),
    surface: Colors.white,
    background: Colors.white,
    error: Color(0xffd91e36),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFF7371fc),
    primaryVariant: Color(0xFFc19bff),
    secondary: Color(0xff03dac6),
    secondaryVariant: Color(0xff03dac6),
    surface: Color(0xff121212),
    background: Color(0xff121212),
    error: Color(0xffcf6679),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  );
}
