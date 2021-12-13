import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:chat/app/middleware/auth_middleware.dart';
import 'package:chat/app/modules/add_profile_image/bindings/add_profile_image_binding.dart';
import 'package:chat/app/modules/add_profile_image/views/add_profile_image_view.dart';
import 'package:chat/app/modules/age_picker/bindings/age_picker_binding.dart';
import 'package:chat/app/modules/age_picker/views/age_picker_view.dart';
import 'package:chat/app/modules/answer/bindings/answer_binding.dart';
import 'package:chat/app/modules/answer/views/answer_view.dart';
import 'package:chat/app/modules/debug/bindings/debug_binding.dart';
import 'package:chat/app/modules/debug/views/debug_view.dart';
import 'package:chat/app/modules/edit_bio/bindings/edit_bio_binding.dart';
import 'package:chat/app/modules/edit_bio/views/edit_bio_view.dart';
import 'package:chat/app/modules/edit_info/bindings/edit_info_binding.dart';
import 'package:chat/app/modules/edit_info/views/edit_info_view.dart';
import 'package:chat/app/modules/edit_name/bindings/edit_name_binding.dart';
import 'package:chat/app/modules/edit_name/views/edit_name_view.dart';
import 'package:chat/app/modules/gender_select/bindings/gender_select_binding.dart';
import 'package:chat/app/modules/gender_select/views/gender_select_view.dart';
import 'package:chat/app/modules/login/bindings/login_binding.dart';
import 'package:chat/app/modules/login/views/login_view.dart';
import 'package:chat/app/modules/main/bindings/main_binding.dart';
import 'package:chat/app/modules/main/views/main_view.dart';
import 'package:chat/app/modules/me/bindings/me_binding.dart';
import 'package:chat/app/modules/me/views/me_view.dart';
import 'package:chat/app/modules/my_single_post/bindings/my_single_post_binding.dart';
import 'package:chat/app/modules/my_single_post/views/my_single_post_view.dart';
import 'package:chat/app/modules/notfound/bindings/notfound_binding.dart';
import 'package:chat/app/modules/notfound/views/notfound_view.dart';
import 'package:chat/app/modules/room/bindings/room_binding.dart';
import 'package:chat/app/modules/room/views/room_view.dart';
import 'package:chat/app/modules/root/bindings/root_binding.dart';
import 'package:chat/app/modules/root/views/root_view.dart';
import 'package:chat/app/modules/setting/bindings/setting_binding.dart';
import 'package:chat/app/modules/setting/views/setting_view.dart';
import 'package:chat/app/modules/test1/bindings/test1_binding.dart';
import 'package:chat/app/modules/test1/views/test1_view.dart';
import 'package:chat/app/modules/test2/bindings/test2_binding.dart';
import 'package:chat/app/modules/test2/views/test2_view.dart';
import 'package:chat/app/modules/test3/bindings/test3_binding.dart';
import 'package:chat/app/modules/test3/views/test3_view.dart';
import 'package:chat/app/modules/verification/bindings/verification_binding.dart';
import 'package:chat/app/modules/verification/views/verification_view.dart';
import 'package:chat/app/modules/post/views/post_view.dart';
import 'package:chat/app/modules/post/bindings/post_binding.dart';

import 'observers.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ROOT;
  static const UNKNOWN_PAGE = Routes.NOTFOUND;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];
  static final routes = [
    GetPage(
      name: _Paths.NOTFOUND,
      page: () => NotfoundView(),
      binding: NotfoundBinding(),
    ),
    GetPage(
      name: _Paths.ROOT,
      preventDuplicates: true,
      page: () => RootView(),
      binding: RootBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      preventDuplicates: true,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.POST,
      page: () => PostView(),
      binding: PostBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        // bug
        // EnsureNotAuthedMiddleware(),
      ],
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.ROOM,
      page: () => RoomView(),
      binding: RoomBinding(),
    ),
    GetPage(
      name: _Paths.TEST1,
      page: () => Test1View(),
      binding: Test1Binding(),
    ),
    GetPage(
      name: _Paths.TEST2,
      page: () => Test2View(),
      binding: Test2Binding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.TEST3,
      page: () => Test3View(),
      binding: Test3Binding(),
    ),
    GetPage(
      name: _Paths.DEBUG,
      page: () => DebugView(),
      binding: DebugBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATION,
      page: () => VerificationView(),
      binding: VerificationBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.ANSWER,
      page: () => AnswerView(),
      binding: AnswerBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.ME,
      page: () => MeView(),
      binding: MeBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.EDIT_INFO,
      page: () => EditInfoView(),
      binding: EditInfoBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.EDIT_NAME,
      page: () => EditNameView(),
      binding: EditNameBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.GENDER_SELECT,
      page: () => GenderSelectView(),
      binding: GenderSelectBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.MY_SINGLE_POST,
      page: () => MySinglePostView(),
      binding: MySinglePostBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.AGE_PICKER,
      page: () => AgePickerView(),
      binding: AgePickerBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.ADD_PROFILE_IMAGE,
      page: () => AddProfileImageView(),
      binding: AddProfileImageBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.EDIT_BIO,
      page: () => EditBioView(),
      binding: EditBioBinding(),
    ),
  ];
}
