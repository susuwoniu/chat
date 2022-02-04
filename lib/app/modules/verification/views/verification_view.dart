import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verification_controller.dart';
import 'package:chat/common.dart';
import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../login/views/bear_log_in_controller.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:timer_count_down/timer_count_down.dart';

class VerificationView extends GetView<VerificationController> {
  @override
  Widget build(BuildContext context) {
    return PinCodeVerificationScreen(); // a random number, please don't call xD
  }
}

class PinCodeVerificationScreen extends StatefulWidget {
  PinCodeVerificationScreen();

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  late bear_log_in_Controller _bear_log_inController;
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;

  String currentText = VerificationController.to.verificationCode.value;
  final TextEditingController textEditingController = TextEditingController(
      text: VerificationController.to.verificationCode.value);

  final formKey = GlobalKey<FormState>();
  final controller = VerificationController.to;

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
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          title: Text(
            "Verification".tr,
            style: TextStyle(fontSize: 16),
          ),
          bottom: PreferredSize(
              child: Container(
                height: 0.5,
                color: Colors.grey.shade400,
              ),
              preferredSize: Size.fromHeight(0)),
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(children: <Widget>[
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
                Container(
                  padding: EdgeInsets.fromLTRB(30, 25, 30, 0),
                  child: Column(children: [
                    Text(
                      "we_have_sent_the_code_to_your_phone".tr,
                    ),
                    Text(
                      "${controller.countryCode}${controller.phoneNumber}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                          height: 1.8),
                    ),
                  ]),
                ),
                SizedBox(height: 10),
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
                            borderWidth: 1,
                            shape: PinCodeFieldShape.underline,
                            activeColor: Colors.grey.shade600,
                            inactiveColor: Colors.grey.shade600,
                            selectedColor: Colors.grey.shade600,
                            disabledColor: Colors.transparent,
                            errorBorderColor: Colors.grey.shade600,
                            activeFillColor: Colors.transparent,
                            inactiveFillColor: Colors.transparent,
                            selectedFillColor: Colors.transparent,
                          ),
                          cursorColor: Colors.black54,
                          animationDuration: Duration(milliseconds: 300),
                          enableActiveFill: true,
                          autoFocus: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
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
                            return true;
                          },
                        ))),
                Obx(() => Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: controller.isShowCount.value
                          ? Countdown(
                              seconds: 5,
                              onFinished: () {
                                controller.setShowCount(false);
                              },
                              build: (BuildContext context, double time) {
                                return TextButton(
                                    style: ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                    onPressed: null,
                                    child: Text(
                                        time.round().toString() +
                                            " secends".tr +
                                            "resend".tr,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        )));
                              })
                          : TextButton(
                              style: ButtonStyle(
                                splashFactory: NoSplash.splashFactory,
                                foregroundColor: MaterialStateProperty.all<
                                        Color>(
                                    Theme.of(context).colorScheme.onBackground),
                              ),
                              onPressed: () async {
                                try {
                                  await controller.handleSendCode();
                                  controller.setShowCount(true);
                                  UIUtils.toast(
                                      'A_verification_code_has_been_sent_to_your_phone.'
                                          .tr);
                                } catch (e) {
                                  UIUtils.showError(e);
                                }
                              },
                              child: Text("Resend".tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ))),
                    )),
                SizedBox(height: 10),
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
                              },
                            );
                            controller.setVerificationCode(currentText);
                          }
                          try {
                            await AccountProvider.to.handleLogin(
                                controller.countryCode,
                                controller.phoneNumber,
                                controller.verificationCode.value,
                                closePageCount: 1,
                                arguments: Get.arguments);
                          } catch (e) {
                            UIUtils.showError(e);
                          }
                        },
                        child: Center(
                            child: Text(
                          "Submit".tr,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                        ))),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ]),
            )));
  }
}
