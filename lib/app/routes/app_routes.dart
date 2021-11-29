part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const ROOT = _Paths.ROOT;
  static const SPLASH = _Paths.SPLASH;
  static const NOTFOUND = _Paths.NOTFOUND;
  static const MAIN = _Paths.MAIN;
  static const HOME = _Paths.MAIN + _Paths.HOME;
  static const POST = _Paths.MAIN + _Paths.POST;
  static const MESSAGE = _Paths.MAIN + _Paths.MESSAGE;
  static const TEST1 = _Paths.MAIN + _Paths.MESSAGE + _Paths.TEST1;
  static const TEST2 = _Paths.TEST2;
  static const LOGIN = _Paths.LOGIN;
  static const ME = _Paths.ME;

  static String LOGIN_NEXT(String? afterSuccessfulLogin,
          [String? redirectAction]) =>
      '$_Paths.LOGIN?next=${Uri.encodeQueryComponent(afterSuccessfulLogin ?? "/app")}&action=${redirectAction == '/app' ? "offAll" : "off"}';
  static const SETTING = _Paths.SETTING;
  static const ROOM = _Paths.ROOM;
  static const TEST3 = _Paths.TEST3;
  static const DEBUG = _Paths.DEBUG;
  static const ENSURE_AUTH_PAGES = [TEST3];
  static const VERIFICATION = _Paths.VERIFICATION;
  static const ANSWER = _Paths.ANSWER;
  static const CHAT = _Paths.CHAT;
  static const EDIT_INFO = _Paths.EDIT_INFO;
  static const EDIT_INPUT = _Paths.EDIT_INPUT;
}

abstract class _Paths {
  static const ROOT = '/';
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
  static const VERIFICATION = '/verification';
  static const ANSWER = '/answer';
  static const CHAT = '/chat';
  static const ME = '/me';
  static const EDIT_INFO = '/edit-info';
  static const EDIT_INPUT = '/edit-input';
}
