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
      backgroundColor: colorScheme.background,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: colorScheme.background,
          foregroundColor: colorScheme.onSurface),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.transparent),
    );
  }

  static const Color baseBlack = Color(0xff121212);
  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFF7371fc),
    primaryVariant: Color(0xFFc19bff),
    secondary: Color(0xff46494c),
    secondaryVariant: Color(0xff018786),
    surface: Colors.white,
    background: Color(0xfff2f2f7),
    error: Color(0xffd91e36),
    onPrimary: Colors.white,
    onSecondary: baseBlack,
    onSurface: baseBlack,
    onBackground: baseBlack,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFFbb99ff),
    primaryVariant: Color(0x5f527a),
    secondary: Color(0xffee99ff),
    secondaryVariant: Color(0xffee99ff),
    surface: baseBlack,
    // background: Color(0xff1f1c38),
    background: Color(0xff222639),
    error: Color(0xffcf6679),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: baseBlack,
    brightness: Brightness.dark,
  );
}
