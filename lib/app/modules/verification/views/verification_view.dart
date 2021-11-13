import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import '../../login/controllers/login_controller.dart';

import '../controllers/verification_controller.dart';
import 'package:chat/common.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../login/views/bear_log_in_controller.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';

// const List<TextInputFormatter> limit = <TextInputFormatter>[
//   FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
// ];

class VerificationView extends GetView<VerificationController> {
  @override
  Widget build(BuildContext context) {
    return PinCodeVerificationScreen(
        "+8801376221100"); // a random number, please don't call xD
  }
}

class PinCodeVerificationScreen extends StatefulWidget {
  final String? phoneNumber;

  PinCodeVerificationScreen(this.phoneNumber);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";
  late bear_log_in_Controller _bear_log_inController;
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  final _controller = LoginController.to;
  @override
  void initState() {
    _bear_log_inController = bear_log_in_Controller();
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Container(
                      height: 200,
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: FlareActor(
                        "assets/Teddy.flr",
                        shouldClip: false,
                        alignment: Alignment.bottomCenter,
                        fit: BoxFit.contain,
                        controller: _bear_log_inController,
                      ))),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  "please_fill_up_all_the_cells_properly".tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "we_have_sent_the_code_to_your_phone".tr,
                      children: [
                        TextSpan(
                            text: "${widget.phoneNumber}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black54,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      autoDisposeControllers: false,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        if (value.isNotEmpty) {
                          _bear_log_inController.coverEyes(true);
                        } else {
                          _bear_log_inController.coverEyes(false);
                        }
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "didn_t_receive_the_code".tr,
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  TextButton(
                      onPressed: () => snackBar("OTP resend!!"),
                      child: Text(
                        "resend".tr,
                        style: TextStyle(
                            color: Color(0xFF91D3B3),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () async {
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != 6 || currentText != "123456") {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        setState(
                          () {
                            hasError = false;
                            snackBar("OTP Verified!!");
                          },
                        );
                      }
                      try {
                        await _controller.handleLogin();
                        UIUtils.toast('登录成功');
                        // 检测 next 参数，如果有，则跳转到next参数页面，没有则跳转到首页
                        final next = Get.parameters['next'] ??
                            Get.arguments?['next'] ??
                            Routes.MAIN;
                        final defaultAction =
                            next.startsWith(Routes.MAIN) ? "offAll" : "off";
                        final action = Get.parameters['action'] ??
                            Get.arguments?['action'] ??
                            defaultAction;
                        if (action == 'offAll') {
                          Get.offAllNamed(next);
                        } else {
                          Get.offNamed(next);
                        }
                      } catch (e) {
                        UIUtils.showError(e);
                      }
                    },
                    child: Center(
                        child: Text(
                      "submit".tr.toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.blue.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              MaterialButton(
                  child: Text(
                    '测试请求 !!',
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  onPressed: () async {
                    try {
                      await _controller.getMe();
                      UIUtils.toast('成功请求');
                    } catch (e) {
                      UIUtils.showError(e);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
