import 'package:flutter/material.dart';

class AgeWidget extends StatelessWidget {
  final String age;
  final String gender;
  final double? iconSize;
  final double? fontSize;
  final Color? background;
  final Color? color;
  AgeWidget({
    Key? key,
    required this.age,
    required this.gender,
    this.iconSize = 18,
    this.fontSize = 15,
    this.background = Colors.white70,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _genderIcon = gender == 'unknown'
        ? Icons.help_outline_rounded
        : gender == 'female'
            ? Icons.female
            : Icons.male;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Row(children: [
          Icon(
            _genderIcon,
            color: color ?? Theme.of(context).colorScheme.secondary,
            size: iconSize!,
          ),
          Text(age,
              style: TextStyle(
                  fontSize: fontSize!,
                  color: color ?? Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold))
        ]),
        decoration: BoxDecoration(
            color: background!, borderRadius: BorderRadius.circular(5)));
  }
}
