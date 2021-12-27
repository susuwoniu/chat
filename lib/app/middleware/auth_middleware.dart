import 'package:get/get.dart';
import '../routes/app_pages.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';

class EnsureAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route, RouteSettings? routeSettings) {
    // parse route
    if (AuthProvider.to.isLogin ||
        route == Routes.LOGIN ||
        route == AppPages.INITIAL) {
      return null;
    } else if (route != null) {
      final arguments = NextPage(
              route: route,
              mode: NextMode.Off,
              arguments: routeSettings!.arguments)
          .toArguments();
      return RouteSettings(name: Routes.LOGIN, arguments: arguments);
    } else {
      return null;
    }
  }
}
