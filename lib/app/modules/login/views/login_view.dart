import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import 'package:chat/common.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'signin_button.dart';
import 'bear_log_in_controller.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'input_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey _fieldKey = GlobalKey();

  Timer? _debounceTimer;
  final TextEditingController textEditingController =
      TextEditingController(text: LoginController.to.phoneNumber.value);
  late bear_log_in_Controller _bear_log_inController;
  final FocusNode _focusNode = FocusNode();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  initState() {
    textEditingController.addListener(() {
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
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(
            'Login'.tr,
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              child: Stack(children: <Widget>[
                Positioned.fill(
                    child: Container(
                        decoration: BoxDecoration(
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.0, 1.0],
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryVariant,
                    ],
                  ),
                ))),
                Positioned.fill(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: _height * 0.2,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: FlareActor(
                                    "assets/Teddy.flr",
                                    shouldClip: false,
                                    alignment: Alignment.bottomCenter,
                                    fit: BoxFit.contain,
                                    controller: _bear_log_inController,
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25.0),
                                      )),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 15),
                                      child: Form(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              InternationalPhoneNumberInput(
                                                inputKey: _fieldKey,
                                                focusNode: _focusNode,
                                                onInputChanged:
                                                    (PhoneNumber number) {
                                                  _controller.setPhoneNumber(
                                                      number.phoneNumber ?? '',
                                                      number.dialCode ?? '');
                                                  _controller.setCountryCode(
                                                      number.dialCode ?? '');
                                                },
                                                onSubmit: handleSubmit,
                                                selectorConfig: SelectorConfig(
                                                  selectorType:
                                                      PhoneInputSelectorType
                                                          .DIALOG,
                                                  useEmoji: true,
                                                  trailingSpace: false,
                                                ),
                                                ignoreBlank: false,
                                                autoValidateMode:
                                                    AutovalidateMode.disabled,
                                                selectorTextStyle: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                initialValue: PhoneNumber(
                                                    isoCode: "CN",
                                                    dialCode: _controller
                                                        .countryCode.value,
                                                    phoneNumber: _controller
                                                        .phoneNumber.value),
                                                textFieldController:
                                                    textEditingController,
                                                formatInput: false,
                                                textAlignVertical:
                                                    TextAlignVertical.top,
                                                textStyle: (TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                )),
                                                keyboardAction:
                                                    TextInputAction.done,
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                hintText:
                                                    "what_s_your_phone_number"
                                                        .tr,
                                                autoFocus: true,
                                                onSaved: (PhoneNumber number) {
                                                  print('On Saved: $number');
                                                },
                                              ),
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(top: 30),
                                                  child: SigninButton(
                                                      child: Text("next".tr,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "RobotoMedium",
                                                            fontSize: 16,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary,
                                                          )),
                                                      onPressed: handleSubmit)),
                                            ]),
                                      ))),
                            ])))
              ]),
            )));
  }

  Future<void> handleSubmit() async {
    final _controller = LoginController.to;

    // first set Phonnumber with latest value

    if (!_controller.isNumberValid.value) {
      UIUtils.toast("please_enter_correct_phone_number".tr);
      return;
    }

    _focusNode.unfocus();
    try {
      await _controller.handleSendCode();
      UIUtils.toast('验证码发送成功');
      final currentArguments = Get.arguments ?? {};
      Get.toNamed(Routes.VERIFICATION, arguments: {
        ...currentArguments,
        "countryCode": _controller.countryCode.value,
        "phoneNumber": _controller.phoneNumber.value
      });
    } catch (e) {
      UIUtils.showError(e);
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
