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
      scaffoldBackgroundColor: colorScheme.background,
      canvasColor: baseBlack,
      colorScheme: colorScheme,
      textSelectionTheme:
          TextSelectionThemeData(selectionColor: colorScheme.primaryVariant),
      appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.transparent),
    );
  }

  static const Color baseBlack = Color(0xff121212);
  static const Color secondaryBlack = Color(0xff46494c);
  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFF7371fc),
    primaryVariant: Color(0xFFc19bff),
    // secondary: Color(0xff46494c),
    // secondaryVariant: Color(0xff018786),
    secondary: Color(0xffcc4c33),
    secondaryVariant: Color(0xfff0dfdb),
    surface: Colors.white,
    background: Color(0xfff2f2f7),
    error: Color(0xffd91e36),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xff46494c),
    onBackground: baseBlack,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFF7371fc),
    primaryVariant: Color(0xFFc19bff),
    // secondary: Color(0xff46494c),
    secondary: Color(0xFF7371fc),
    secondaryVariant: Color(0xffee99ff),
    surface: Color(0xff222639),
    // background: Color(0xff1f1c38),
    background: Color(0xff1A1A1A),
    error: Color(0xffcf6679),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: baseBlack,
    brightness: Brightness.dark,
  );
}
