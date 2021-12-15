import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import 'package:chat/common.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/rendering.dart';
import 'signin_button.dart';
import 'bear_log_in_controller.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/services.dart';

import 'input_helper.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Login Page');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey _fieldKey = GlobalKey();

  Timer? _debounceTimer;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'CN';
  PhoneNumber number = PhoneNumber(isoCode: 'CN');
  late bear_log_in_Controller _bear_log_inController;
  @override
  initState() {
    controller.addListener(() {
      // We debounce the listener as sometimes the caret position is updated after the listener
      // this assures us we get an accurate caret position.
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (_fieldKey.currentContext != null) {
          // Find the render editable in the field.
          final RenderObject? fieldBox =
              _fieldKey.currentContext?.findRenderObject();
          var caretPosition =
              fieldBox is RenderBox ? getCaretPosition(fieldBox) : null;

          _bear_log_inController.lookAt(caretPosition);
        }
      });
    });

    _bear_log_inController = bear_log_in_Controller();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _controller = LoginController.to;
    return Scaffold(
        backgroundColor: Color.fromRGBO(93, 142, 155, 1.0),
        appBar: AppBar(
          title: Text('LoginView'),
          centerTitle: true,
        ),
        body: Container(
          child: Stack(children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.0, 1.0],
                    colors: [
                      Color(0xff00BFA5),
                      Color(0xff64FFDA),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            height: 200,
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: FlareActor(
                              "assets/Teddy.flr",
                              shouldClip: false,
                              alignment: Alignment.bottomCenter,
                              fit: BoxFit.contain,
                              controller: _bear_log_inController,
                            )),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Form(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      InternationalPhoneNumberInput(
                                        inputKey: _fieldKey,
                                        onInputChanged: (PhoneNumber number) {
                                          _controller.setPhoneNumber(
                                              number.phoneNumber ?? '',
                                              number.dialCode ?? '');
                                          _controller.setCountryCode(
                                              number.dialCode ?? '');
                                        },
                                        onInputValidated: (bool value) {
                                          print(value);
                                        },
                                        selectorConfig: SelectorConfig(
                                          selectorType:
                                              PhoneInputSelectorType.DIALOG,
                                          useEmoji: true,
                                          trailingSpace: false,
                                        ),
                                        ignoreBlank: false,
                                        autoValidateMode:
                                            AutovalidateMode.disabled,
                                        selectorTextStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        initialValue: number,
                                        textFieldController: controller,
                                        formatInput: false,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        textStyle: (TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        )),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: true, decimal: true),
                                        inputBorder: null,
                                        hintText: "what_s_your_phone_number".tr,
                                        autoFocus: true,
                                        onSaved: (PhoneNumber number) {
                                          print('On Saved: $number');
                                        },
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(top: 35),
                                          child: SigninButton(
                                            child: Text("next".tr,
                                                style: TextStyle(
                                                  fontFamily: "RobotoMedium",
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                )),
                                            onPressed: () async {
                                              if (!_controller
                                                  .isNumberValid.value) {
                                                UIUtils.toast(
                                                    "please_enter_correct_phone_number"
                                                        .tr);
                                                return;
                                              }
                                              try {
                                                await _controller
                                                    .handleSendCode();
                                                UIUtils.toast('验证码发送成功');
                                              } catch (e) {
                                                UIUtils.showError(e);
                                              }
                                              Get.toNamed(Routes.VERIFICATION);
                                            },
                                          )),
                                    ]),
                              ),
                            )),
                      ])),
            )
          ]),
        ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
