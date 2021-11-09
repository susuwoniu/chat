import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import '../controllers/login_controller.dart';
import 'package:chat/common.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:flutter/services.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/rendering.dart';
import 'signin_button.dart';
import 'bear_log_in_controller.dart';
import 'tracking_text_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'CN';
  PhoneNumber number = PhoneNumber(isoCode: 'CN');
  late bear_log_in_Controller _bear_log_inController;
  @override
  initState() {
    _bear_log_inController = bear_log_in_Controller();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final _controller = LoginController.to;
    return Scaffold(
      backgroundColor: Color.fromRGBO(93, 142, 155, 1.0),
      body: Container(
        child: Stack(
          children: <Widget>[
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
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: devicePadding.top + 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: 200,
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InternationalPhoneNumberInput(
                                // onCaretMoved: (Offset? caret) {
                                //   _bear_log_inController.lookAt(caret);
                                // },
                                onInputChanged: (PhoneNumber number) {
                                  print(number.phoneNumber);
                                },
                                onInputValidated: (bool value) {
                                  print(value);
                                },
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                  useEmoji: true,
                                ),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle:
                                    TextStyle(color: Colors.black),
                                initialValue: number,
                                textFieldController: controller,
                                formatInput: false,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                inputBorder: null,
                                hintText: "what_s_your_phone_number".tr,
                                autoFocus: true,
                                onSaved: (PhoneNumber number) {
                                  print('On Saved: $number');
                                },
                              ),
                              // TrackingTextInput(
                              //   label: "phone_number".tr,
                              //   hint: "what_s_your_phone_number".tr,
                              //   onCaretMoved: (Offset? caret) {
                              //     _bear_log_inController.lookAt(caret);
                              //   },
                              // ),
                              Container(
                                  // margin: EdgeInsets.only(top: 35),
                                  child: SigninButton(
                                child: Text("next".tr,
                                    style: TextStyle(
                                      fontFamily: "RobotoMedium",
                                      fontSize: 16,
                                      color: Colors.white,
                                    )),
                                onPressed: () {
                                  Get.toNamed(Routes.VERIFICATION);
                                },
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
