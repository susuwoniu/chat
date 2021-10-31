import 'package:get/get.dart';

import 'package:chat/app/modules/home/bindings/home_binding.dart';
import 'package:chat/app/modules/home/views/home_view.dart';
import 'package:chat/app/modules/message/bindings/message_binding.dart';
import 'package:chat/app/modules/message/views/message_view.dart';
import 'package:chat/app/modules/notfound/bindings/notfound_binding.dart';
import 'package:chat/app/modules/notfound/views/notfound_view.dart';
import 'package:chat/app/modules/splash/bindings/splash_binding.dart';
import 'package:chat/app/modules/splash/views/splash_view.dart';
import 'package:chat/app/modules/start/bindings/start_binding.dart';
import 'package:chat/app/modules/start/views/start_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.START;
  static const UNKNOWN_PAGE = Routes.NOTFOUND;
  static final routes = [
    GetPage(
      name: _Paths.START,
      page: () => StartView(),
      binding: StartBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.NOTFOUND,
      page: () => NotfoundView(),
      binding: NotfoundBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGE,
      page: () => MessageView(),
      binding: MessageBinding(),
    ),
  ];
}
