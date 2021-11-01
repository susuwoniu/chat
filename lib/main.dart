import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/routes/app_pages.dart';
import "package:chat/langs/translation_service.dart";
import "app/store/store.dart";
import "global.dart";
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:chat/app/store/config.dart';

Future<void> main() async {
  await Global.init();

  runApp(
    GetMaterialApp.router(
      title: "Application",
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: FlexColorScheme.light(scheme: FlexScheme.materialHc).toTheme,
      // The Mandy red, dark theme.
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.materialHc).toTheme,
      // Use dark or light theme based on system setting.
      themeMode:
          ConfigStore.to.nightMode.isTrue ? ThemeMode.dark : ThemeMode.light,
      enableLog: true,
      builder: EasyLoading.init(),
      unknownRoute: AppPages.routes[0].children[0],
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
