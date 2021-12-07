import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenderPicker extends StatelessWidget {
  final String selectedGender;
  final Function setGender;

  GenderPicker({
    required this.selectedGender,
    required this.setGender,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_gender("female"), _gender("male")]);
  }

  Widget _gender(gender) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              setGender(gender);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              padding: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      width: 4,
                      color: selectedGender == gender
                          ? Colors.lightBlue
                          : Colors.black12)),
              child: Column(children: [
                Text(
                  gender == "female" ? "👩" : "👨",
                  style: TextStyle(fontSize: 60),
                ),
                Text(gender == 'female' ? 'female'.tr : 'male'.tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: selectedGender == gender
                            ? Colors.lightBlue
                            : Colors.black54))
              ]),
            )));
  }
}
