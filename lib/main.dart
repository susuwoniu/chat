import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/routes/app_pages.dart';
import "package:chat/langs/translation_service.dart";
import 'app/styles/styles.dart';
import "app/store/store.dart";
import "global.dart";

Future<void> main() async {
  await Global.init();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
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
