import 'package:flutter/material.dart';
import '../controllers/report_controller.dart';
import 'bottom_sheet_row.dart';
import 'package:get/get.dart';

class ReportSheet extends StatelessWidget {
  final controller = ReportController.to;

  @override
  Widget build(BuildContext context) {
    return Wrap(alignment: WrapAlignment.center, children: [
      Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            BottomSheetRow(
                text: 'Fraud'.tr,
                onPressed: () {
                  controller.setReportType('spam');
                }),
            Container(height: 1, color: Theme.of(context).dividerColor),
            BottomSheetRow(
                text: 'Harassing'.tr,
                onPressed: () {
                  controller.setReportType('offensive');
                }),
            Container(height: 1, color: Theme.of(context).dividerColor),
            BottomSheetRow(
                text: 'Crime_and_illegal_activities'.tr,
                onPressed: () {
                  controller.setReportType('illegal');
                }),
            Container(height: 1, color: Theme.of(context).dividerColor),
            BottomSheetRow(
                text: 'Other'.tr,
                onPressed: () {
                  controller.setReportType('complaint');
                }),
            Container(height: 8, color: Theme.of(context).dividerColor),
            BottomSheetRow(text: 'Cancel'.tr, onPressed: () {}),
          ]))
    ]);
  }
}
