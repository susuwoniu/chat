import 'package:flutter/material.dart';

class BottomSheetRow extends StatelessWidget {
  final String text;

  BottomSheetRow({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 14),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 17, color: Theme.of(context).colorScheme.onSurface),
            )));
  }
}
