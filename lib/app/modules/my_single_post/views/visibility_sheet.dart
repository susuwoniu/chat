import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../report/views/bottom_sheet_row.dart';

const _title = ['public', 'private', 'cancel'];
const _list = ['Visible_to_public', 'Visible_to_yourself', 'Cancel'];

class VisibilitySheet extends StatelessWidget {
  final Function(String visibility) onPressedVisibility;

  VisibilitySheet({
    Key? key,
    required this.onPressedVisibility,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _title.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onPressedVisibility(_title[index]);
                },
                child: BottomSheetRow(text: _list[index].tr));
          },
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 1),
        ));
  }
}
