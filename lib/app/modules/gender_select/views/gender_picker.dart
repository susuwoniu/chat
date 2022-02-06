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
        children: [_gender(context, "female"), _gender(context, "male")]);
  }

  Widget _gender(BuildContext context, String gender) {
    return GestureDetector(
        onTap: () {
          setGender(gender);
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          padding: EdgeInsets.only(bottom: 15, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  width: 4,
                  color: selectedGender == gender
                      ? Colors.pink.shade300
                      : Theme.of(context).dividerColor)),
          child: Column(children: [
            Text(
              gender == "female" ? "👩" : "👨",
              style: TextStyle(fontSize: 60),
            ),
            Text(gender == 'female' ? 'female'.tr : 'male'.tr,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: selectedGender == gender
                        ? Colors.pink.shade300
                        : Theme.of(context).colorScheme.onSurface))
          ]),
        ));
  }
}
