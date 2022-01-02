import 'package:flutter/material.dart';
import '../../report/views/bottom_sheet_row.dart';

class VisibilitySheet extends StatelessWidget {
  final Function(String visibility) onPressedVisibility;

  VisibilitySheet({
    Key? key,
    required this.onPressedVisibility,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(alignment: WrapAlignment.center, children: [
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          BottomSheetRow(
              text: 'Public',
              onPressed: () {
                onPressedVisibility('public');
              }),
          Container(height: 1, color: Colors.grey.shade100),
          BottomSheetRow(
              text: 'Private',
              onPressed: () {
                onPressedVisibility('private');
              }),
          Container(height: 8, color: Colors.grey.shade100),
          BottomSheetRow(text: 'Cancle', onPressed: () {}),
        ]),
      )
    ]);
  }
}
