import 'package:get/get.dart';
import 'package:chat/app/services/services.dart';
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
    await AuthService.to.login();

    // final token = await _apiProvider.loginWithPhone();
    // print(token);

    // Get.offAndToNamed(AppRoutes.Application);
  }
}
