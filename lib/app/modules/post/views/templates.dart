import 'package:flutter/material.dart';

class Templates extends StatelessWidget {
  final String question;
  final String id;
  final Function(String text)? onChanged;
  final Color color;
  Templates({
    Key? key,
    required this.question,
    required this.color,
    required this.id,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _marginWidth = _width * 0.07;
    final finalQuestion = question.replaceAll('____', ' ____________');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _marginWidth),
      child: Column(children: [
        SizedBox(height: 25),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            finalQuestion,
            style: TextStyle(fontSize: 22.0, color: color),
          ),
        ),
      ]),
    );
  }
}
