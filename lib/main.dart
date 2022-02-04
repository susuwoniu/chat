import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/routes/app_pages.dart';
import "package:chat/langs/translation_service.dart";
import './theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/config/config.dart';
import 'global.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

Future<void> main() async {
  const String env = String.fromEnvironment(
    'env',
    defaultValue: AppConfig.DEV,
  );
  await Global.init();
  // run global timer task
  await Global().runGlobalTask();
  runApp(Phoenix(
    child: GetMaterialApp(
      title: "Application",
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      theme: ChatThemeData.lightThemeData,
      // The Mandy red, dark theme.
      darkTheme: ChatThemeData.darkThemeData,
      // Use dark or light theme based on system setting.
      themeMode:
          ConfigProvider.to.nightMode.isTrue ? ThemeMode.dark : ThemeMode.light,
      enableLog: env == "prod" ? false : true,
      builder: EasyLoading.init(
          builder: (context, widget) => ResponsiveWrapper.builder(
                widget,
                maxWidth: 1024,
                minWidth: 390,
                defaultScale: true,
                breakpoints: [
                  ResponsiveBreakpoint.resize(390, name: MOBILE),
                  ResponsiveBreakpoint.autoScale(480, name: MOBILE),
                  ResponsiveBreakpoint.resize(768, name: TABLET),
                  ResponsiveBreakpoint.autoScale(1024, name: DESKTOP),
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
      navigatorObservers: [AppPages.observer],
      supportedLocales: ConfigProvider.to.languages,
      locale: ConfigProvider.to.locale,
      fallbackLocale: TranslationService.fallbackLocale,
    ),
  ));
}
