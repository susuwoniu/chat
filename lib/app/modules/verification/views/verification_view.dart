import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/controllers/login_controller.dart';

import '../controllers/verification_controller.dart';
import 'package:chat/common.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../login/views/bear_log_in_controller.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:timer_count_down/timer_count_down.dart';

class VerificationView extends GetView<VerificationController> {
  @override
  Widget build(BuildContext context) {
    return PinCodeVerificationScreen(
        ""); // a random number, please don't call xD
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("verification_title".tr),
        centerTitle: true,
      ),
      body: GestureDetector(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 5.5,
                  child: Container(
                      height: 200,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: FlareActor(
                        "assets/Teddy.flr",
                        shouldClip: false,
                        alignment: Alignment.bottomCenter,
                        fit: BoxFit.contain,
                        controller: _bear_log_inController,
                      ))),
              Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
                  child: Container(
                    child: Column(children: [
                      Text(
                        "we_have_sent_the_code_to_your_phone".tr,
                      ),
                      Text(
                        "${_controller.countryCode}${_controller.phoneNumber}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.8),
                      ),
                    ]),
                  )),
              SizedBox(
                height: 15,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
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
                      autoFocus: true,
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
              Container(
                padding: const EdgeInsets.only(left: 23),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Countdown(
                    seconds: 5,
                    build: (BuildContext context, double time) {
                      if (time > 0) {
                        return TextButton(
                          style: ButtonStyle(),
                          onPressed: null,
                          child: Text(
                              time.round().toString() +
                                  "secends".tr +
                                  "resend".tr,
                              style: TextStyle(
                                color: Colors.blue.shade300,
                                fontSize: 15,
                              )),
                        );
                      } else {
                        return TextButton(
                          onPressed: () async {
                            try {
                              await _controller.handleSendCode();
                              UIUtils.toast('验证码发送成功');
                            } catch (e) {
                              UIUtils.showError(e);
                            }
                          },
                          child: Text(
                            "resend".tr,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                    },
                    interval: Duration(milliseconds: 1000),
                    onFinished: () {
                      print('Timer is done!');
                    },
                  ),
                ]),
              ),
              SizedBox(
                height: 10,
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
                      if (currentText.length != 6) {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        setState(
                          () {
                            hasError = false;
                            _controller.setVerificationCode(currentText);
                          },
                        );
                      }
                      try {
                        await AccountProvider.to.handleLogin(
                            _controller.countryCode.value,
                            _controller.phoneNumber.value,
                            _controller.verificationCode.value,
                            closePageCount: 1);
                        UIUtils.toast('登录成功');
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
            ],
          ),
        ),
      ),
    );
  }
}
