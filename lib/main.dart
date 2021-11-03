import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/routes/app_pages.dart';
import "package:chat/langs/translation_service.dart";
import "app/store/store.dart";
import "global.dart";
import 'package:chat/app/store/config.dart';
import './theme.dart';

Future<void> main() async {
  await Global.init();

  runApp(
    GetMaterialApp(
      title: "Application",
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      debugShowCheckedModeBanner: false,
      theme: ChatThemeData.lightThemeData,
      // The Mandy red, dark theme.
      darkTheme: ChatThemeData.darkThemeData,
      // Use dark or light theme based on system setting.
      themeMode:
          ConfigStore.to.nightMode.isTrue ? ThemeMode.dark : ThemeMode.light,
      enableLog: true,
      builder: EasyLoading.init(),
      unknownRoute: AppPages.routes[0],
      translations: TranslationService(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: ConfigStore.to.languages,
      locale: ConfigStore.to.locale,
      fallbackLocale: TranslationService.fallbackLocale,
    ),
  );
}
