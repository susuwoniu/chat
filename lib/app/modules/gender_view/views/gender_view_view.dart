import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/gender_view_controller.dart';
import 'gender_picker.dart';

class GenderViewView extends GetView<GenderViewController> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('GenderViewView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.08, vertical: 5),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Container(
            //   alignment: Alignment.topLeft,
            //   // padding: EdgeInsets.fromLTRB(_width * 0.1, 10, _width * 0.1, 0),
            //   child: Text(
            //     'Please_choose_your_gender_and_age:'.tr,
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            //   ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('I_am'.tr,
                    style: TextStyle(color: Colors.black54, fontSize: 20.0)),
                Obx(() => GenderPicker(
                      selectedGender: controller.selectedGender.value,
                      setGender: controller.setGender,
                    )),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              // padding: EdgeInsets.fromLTRB(_width * 0.1, 10, _width * 0.1, 30),
              child: Text(
                'I_was_born_in'.tr,
                style: TextStyle(color: Colors.black54, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// @override
// Widget getWidget(bool showOtherGender, bool alignVertical) {
//   return Container(
//     margin: EdgeInsets.symmetric(vertical: 40),
//     alignment: Alignment.center,
//     child: GenderPickerWithImage(
//       showOtherGender: showOtherGender,
//       verticalAlignedText: alignVertical,

//       // to show what's selected on app opens, but by default it's Male
//       selectedGender: Gender.Male,
//       selectedGenderTextStyle:
//           TextStyle(color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
//       unSelectedGenderTextStyle:
//           TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
//       onChanged: (Gender? gender) {
//         print(gender);
//       },
//       //Alignment between icons
//       equallyAligned: true,

//       animationDuration: Duration(milliseconds: 300),
//       isCircular: true,
//       // default : true,
//       opacityOfGradient: 0.4,
//       padding: const EdgeInsets.all(3),
//       size: 80, //default : 40
//     ),
//   );
// }
