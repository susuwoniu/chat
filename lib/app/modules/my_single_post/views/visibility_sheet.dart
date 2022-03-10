import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../report/views/bottom_sheet_row.dart';

const _map = {
  'public': 'Visible_to_public',
  'private': 'Visible_to_yourself',
  'cancel': 'Cancel'
};

class VisibilitySheet extends StatelessWidget {
  final Function(String visibility) onPressedVisibility;
  final String current;

  VisibilitySheet({
    Key? key,
    required this.onPressedVisibility,
    required this.current,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List _title = ['public', 'private', 'cancel'];
    _title.removeWhere((item) => item == current);
    _title.join(', ');
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.separated(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: _title.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: BottomSheetRow(text: _map[_title[index]]!.tr),
                onTap: () {
                  Navigator.pop(context);
                  if (index == 0) {
                    onPressedVisibility(_title[index]);
                  }
                });
          },
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 1),
        ));
  }
}
