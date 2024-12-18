import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../middleware/auth_middleware.dart';
import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/advance/bindings/advance_binding.dart';
import '../modules/advance/views/advance_view.dart';
import '../modules/block/bindings/block_binding.dart';
import '../modules/block/views/block_view.dart';
import '../modules/change_gender/bindings/change_gender_binding.dart';
import '../modules/change_gender/views/change_gender_view.dart';
import '../modules/complete_age/bindings/complete_age_binding.dart';
import '../modules/complete_age/views/complete_age_view.dart';
import '../modules/complete_avatar/bindings/complete_avatar_binding.dart';
import '../modules/complete_avatar/views/complete_avatar_view.dart';
import '../modules/complete_bio/bindings/complete_bio_binding.dart';
import '../modules/complete_bio/views/complete_bio_view.dart';
import '../modules/complete_gender/bindings/complete_gender_binding.dart';
import '../modules/complete_gender/views/complete_gender_view.dart';
import '../modules/complete_name/bindings/complete_name_binding.dart';
import '../modules/complete_name/views/complete_name_view.dart';
import '../modules/create/bindings/create_binding.dart';
import '../modules/create/views/create_view.dart';
import '../modules/debug/bindings/debug_binding.dart';
import '../modules/debug/views/debug_view.dart';
import '../modules/edit_bio/bindings/edit_bio_binding.dart';
import '../modules/edit_bio/views/edit_bio_view.dart';
import '../modules/edit_info/bindings/edit_info_binding.dart';
import '../modules/edit_info/views/edit_info_view.dart';
import '../modules/edit_name/bindings/edit_name_binding.dart';
import '../modules/edit_name/views/edit_name_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/feedback/bindings/feedback_binding.dart';
import '../modules/feedback/views/feedback_view.dart';
import '../modules/home_setting/bindings/home_setting_binding.dart';
import '../modules/home_setting/views/home_setting_view.dart';
import '../modules/liked_me/bindings/liked_me_binding.dart';
import '../modules/liked_me/views/liked_me_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/me/bindings/me_binding.dart';
import '../modules/me/views/me_view.dart';
import '../modules/my_single_post/bindings/my_single_post_binding.dart';
import '../modules/my_single_post/views/my_single_post_view.dart';
import '../modules/notfound/bindings/notfound_binding.dart';
import '../modules/notfound/views/notfound_view.dart';
import '../modules/other/bindings/other_binding.dart';
import '../modules/other/views/other_view.dart';
import '../modules/post/bindings/post_binding.dart';
import '../modules/post/views/post_view.dart';
import '../modules/post_square/bindings/post_square_binding.dart';
import '../modules/post_square/views/post_square_card_view.dart';
import '../modules/post_square/views/post_square_view.dart';
import '../modules/profile_viewers/bindings/profile_viewers_binding.dart';
import '../modules/profile_viewers/views/profile_viewers_view.dart';
import '../modules/report/bindings/report_binding.dart';
import '../modules/report/views/report_view.dart';
import '../modules/room/bindings/room_binding.dart';
import '../modules/room/views/room_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/rule/bindings/rule_binding.dart';
import '../modules/rule/views/rule_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/star/bindings/star_binding.dart';
import '../modules/star/views/star_view.dart';
import '../modules/test1/bindings/test1_binding.dart';
import '../modules/test1/views/test1_view.dart';
import '../modules/test2/bindings/test2_binding.dart';
import '../modules/test2/views/test2_view.dart';
import '../modules/test3/bindings/test3_binding.dart';
import '../modules/test3/views/test3_view.dart';
import '../modules/verification/bindings/verification_binding.dart';
import '../modules/verification/views/verification_view.dart';
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
      name: _Paths.HOMESETTING,
      page: () => HomeSettingView(),
      binding: HomeSettingBinding(),
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
      name: _Paths.CHANGE_GENDER,
      page: () => ChangeGenderView(),
      binding: ChangeGenderBinding(),
    ),
    GetPage(
      name: _Paths.MY_SINGLE_POST,
      page: () => MySinglePostView(),
      binding: MySinglePostBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.COMPLETE_AGE,
      page: () => CompleteAgeView(),
      binding: CompleteAgeBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.COMPLETE_AVATAR,
      page: () => CompleteAvatarView(),
      binding: CompleteAvatarBinding(),
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
    GetPage(
      name: _Paths.POST_SQUARE,
      page: () => PostSquareView(),
      binding: PostSquareBinding(),
    ),
    GetPage(
      name: _Paths.POST_SQUARE_CARD_VIEW,
      page: () => PostSquareCardView(),
      binding: PostSquareBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.FEEDBACK,
      page: () => FeedbackView(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
    ),
    GetPage(
      name: _Paths.PROFILE_VIEWERS,
      page: () => ProfileViewersView(),
      binding: ProfileViewersBinding(),
    ),
    GetPage(
      name: _Paths.STAR,
      page: () => StarView(),
      binding: StarBinding(),
    ),
    GetPage(
      name: _Paths.OTHER,
      page: () => OtherView(),
      binding: OtherBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.CREATE,
      page: () => CreateView(),
      binding: CreateBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE,
      page: () => ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.REPORT,
      page: () => ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.LIKEDME,
      page: () => LikedMeView(),
      binding: LikedMeBinding(),
    ),
    GetPage(
      middlewares: [
        //only enter this route when authed
        EnsureAuthMiddleware(),
      ],
      name: _Paths.BLOCK,
      page: () => BlockView(),
      binding: BlockBinding(),
    ),
    GetPage(
      name: _Paths.RULE,
      page: () => RuleView(),
      binding: RuleBinding(),
    ),
    GetPage(
      name: _Paths.COMPLETE_GENDER,
      page: () => CompleteGenderView(),
      binding: CompleteGenderBinding(),
    ),
    GetPage(
      name: _Paths.COMPLETE_NAME,
      page: () => CompleteNameView(),
      binding: CompleteNameBinding(),
    ),
    GetPage(
      name: _Paths.COMPLETE_BIO,
      page: () => CompleteBioView(),
      binding: CompleteBioBinding(),
    ),
    GetPage(
      name: _Paths.ADVANCE,
      page: () => AdvanceView(),
      binding: AdvanceBinding(),
    ),
  ];
}
