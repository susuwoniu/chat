import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/errors/errors.dart';

class LoginController extends GetxController {
  // 执行登录操作
  handleLogin() async {
    // if (!duIsEmail(_emailController.value.text)) {
    //   toastInfo(msg: '请正确输入邮件');
    //   return;
    // }
    // if (!duCheckStringLength(_passController.value.text, 6)) {
    //   toastInfo(msg: '密码不能小于6位');
    //   return;
    // }
    final _apiProvider = ApiProvider();
    try {
      final token = await _apiProvider.loginWithPhone();
      print(token);
    } on ServiceException catch (e) {
      Get.snackbar(e.title, e.detail);
    } catch (e) {
      print(e);
      Get.snackbar("", e.toString());
    }
    // Get.offAndToNamed(AppRoutes.Application);
  }
}
