import 'package:flutter/material.dart';
import 'package:chat/app/widgets/spinner.dart';

class ActionButtons extends StatelessWidget {
  final bool isRefreshing;
  final Function? onRefresh;
  final Function? onAdd;
  final Function? onMore;
  ActionButtons(
      {this.isRefreshing = false, this.onRefresh, this.onAdd, this.onMore});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.12),
              shape: CircleBorder(),
            ),
            child: Icon(Icons.add,
                color: Theme.of(context).colorScheme.onPrimary, size: 28),
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
                    child: Icon(Icons.refresh,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 28))
                : Icon(Icons.refresh,
                    color: Theme.of(context).colorScheme.onPrimary, size: 28),
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
            child: Icon(Icons.more_horiz_outlined,
                color: Theme.of(context).colorScheme.onPrimary, size: 28),
            onPressed: () {
              if (onMore != null) {
                onMore!();
              }
            })
      ],
    );
  }
}
