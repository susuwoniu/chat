import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/routes/app_pages.dart';
import "package:chat/langs/translation_service.dart";
import "global.dart";
import 'package:chat/app/services/services.dart';
import './theme.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
          ConfigService.to.nightMode.isTrue ? ThemeMode.dark : ThemeMode.light,
      enableLog: true,
      builder: EasyLoading.init(
          builder: (context, widget) => ResponsiveWrapper.builder(
                widget,
                maxWidth: 1024,
                minWidth: 390,
                defaultScale: true,
                breakpoints: [
                  ResponsiveBreakpoint.resize(390, name: MOBILE),
                  ResponsiveBreakpoint.autoScale(480, name: MOBILE),
                  ResponsiveBreakpoint.autoScale(768, name: TABLET),
                  ResponsiveBreakpoint.resize(1024, name: DESKTOP),
                ],
              )),
      // builder: EasyLoading.init(builder:),
      unknownRoute: AppPages.routes[0],
      translations: TranslationService(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: ConfigService.to.languages,
      locale: ConfigService.to.locale,
      fallbackLocale: TranslationService.fallbackLocale,
    ),
  );
}
