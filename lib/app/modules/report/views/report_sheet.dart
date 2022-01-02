import 'package:flutter/material.dart';
import '../controllers/report_controller.dart';
import 'report_type.dart';

class ReportSheet extends StatelessWidget {
  final controller = ReportController.to;

  @override
  Widget build(BuildContext context) {
    return Wrap(alignment: WrapAlignment.center, children: [
      Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            ReportType(
                text: 'Fraud',
                onPressed: () {
                  controller.setReportType('spam');
                }),
            ReportType(
                text: 'Harassing',
                onPressed: () {
                  controller.setReportType('offensive');
                }),
            ReportType(
                text: 'Crime_and_illegal_activities',
                onPressed: () {
                  controller.setReportType('illegal');
                }),
            ReportType(
                text: 'Other',
                onPressed: () {
                  controller.setReportType('complaint');
                }),
            ReportType(text: 'Cancel', onPressed: () {}),
          ]))
    ]);
  }
}
