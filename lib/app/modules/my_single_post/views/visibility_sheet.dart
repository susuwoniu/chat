import 'package:flutter/material.dart';
import '../../report/views/bottom_sheet_row.dart';
import 'package:get/get.dart';

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
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          BottomSheetRow(
              text: 'Visible_to_public'.tr,
              onPressed: () {
                onPressedVisibility('public');
              }),
          Container(height: 1, color: Colors.grey.shade100),
          BottomSheetRow(
              text: 'Visible_to_yourself'.tr,
              onPressed: () {
                onPressedVisibility('private');
              }),
          Container(height: 8, color: Colors.grey.shade100),
          BottomSheetRow(text: 'Cancel'.tr, onPressed: () {}),
        ]),
      )
    ]);
  }
}
