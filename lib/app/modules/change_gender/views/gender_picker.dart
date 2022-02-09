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
    return Container(
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_gender(context, "female"), _gender(context, "male")]));
  }

  Widget _gender(BuildContext context, String gender) {
    return GestureDetector(
        onTap: () {
          setGender(gender);
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 25, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  width: 4,
                  color: selectedGender == gender
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor)),
          child: Column(children: [
            Icon(
                gender == "female"
                    ? Icons.female_outlined
                    : Icons.male_outlined,
                color: selectedGender == gender
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                size: 60),
            Text(gender == 'female' ? 'female'.tr : 'male'.tr,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: selectedGender == gender
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface))
          ]),
        ));
  }
}
