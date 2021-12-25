import 'package:flutter/material.dart';
import 'package:chat/app/widgets/spinner.dart';

class ActionButtons extends StatelessWidget {
  final bool isRefreshing;
  final Function? onRefresh;
  final Function? onAdd;
  ActionButtons({this.isRefreshing = false, this.onRefresh, this.onAdd});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.12),
              shape: CircleBorder(),
            ),
            child: Icon(Icons.add, color: Colors.white, size: 28),
            onPressed: () {
              if (onAdd != null) {
                onAdd!();
              }
            }),
        SizedBox(
          height: 12,
        ),
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.12),
              shape: CircleBorder(),
            ),
            child: isRefreshing
                ? Spinner(
                    child: Icon(Icons.refresh, color: Colors.white, size: 28))
                : Icon(Icons.refresh, color: Colors.white, size: 28),
            onPressed: () {
              if (onRefresh != null && !isRefreshing) {
                onRefresh!();
              }
            }),
        SizedBox(
          height: 12,
        ),
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.12),
              shape: CircleBorder(),
            ),
            child:
                Icon(Icons.more_horiz_outlined, color: Colors.white, size: 28),
            onPressed: () {})
      ],
    );
  }
}
