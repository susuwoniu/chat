part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const ROOT = _Paths.ROOT;
  static const START = _Paths.START;
  static const SPLASH = _Paths.SPLASH;
  static const NOTFOUND = _Paths.NOTFOUND;

  static const MAIN = _Paths.MAIN;
  static const HOME = _Paths.MAIN + _Paths.HOME;
  static const POST = _Paths.MAIN + _Paths.POST;
  static const MESSAGE = _Paths.MAIN + _Paths.MESSAGE;
  static const TEST1 = _Paths.MAIN + _Paths.MESSAGE + _Paths.TEST1;
  static const TEST2 = _Paths.TEST2;
  static const LOGIN = _Paths.LOGIN;
  static String LOGIN_THEN(String afterSuccessfulLogin) =>
      '$_Paths.LOGIN?then=${Uri.encodeQueryComponent(afterSuccessfulLogin)}';
  static const SETTING = _Paths.SETTING;
  static const ROOM = _Paths.ROOM;
  static const TEST3 = _Paths.TEST3;
  static const DEBUG = _Paths.DEBUG;
}

abstract class _Paths {
  static const ROOT = '/';
  static const START = '/start';
  static const SPLASH = '/splash';
  static const NOTFOUND = '/notfound';
  static const HOME = '/home';

  static const MAIN = '/app';
  static const POST = '/post';
  static const MESSAGE = '/message';
  static const TEST1 = '/test1';
  static const TEST2 = '/test2';
  static const LOGIN = "/login";
  static const SETTING = '/setting';
  static const ROOM = '/room';
  static const TEST3 = '/test3';
  static const DEBUG = '/debug';
}
