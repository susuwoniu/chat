import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetRow extends StatelessWidget {
  final String text;

  BottomSheetRow({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 18),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 17, color: Theme.of(context).colorScheme.onSurface),
        ));
  }
}
