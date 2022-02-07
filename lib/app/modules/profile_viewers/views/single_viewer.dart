import 'package:chat/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../controllers/profile_viewers_controller.dart';
import 'package:get/get.dart';
import '../../me/views/like_count.dart';
import 'package:intl/intl.dart';
import '../../me/views/vip_icon.dart';

class SingleViewer extends StatelessWidget {
  final Function() onPressed;
  final ViewerEntity viewerAccount;
  final bool isLast;

  SingleViewer({
    Key? key,
    required this.onPressed,
    required this.viewerAccount,
    required this.isLast,
  }) : super(key: key);
  final DateFormat formatter = DateFormat('yyyy-MM-dd  HH:mm');

  @override
  Widget build(BuildContext context) {
    final String updatedAt =
        formatter.format(DateTime.parse(viewerAccount.updatedAt.toString()));

    final times = viewerAccount.viewedCount > 9999
        ? '9999+'
        : viewerAccount.viewedCount.toString();

    return Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(children: [
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(12, 4, 15, 4),
            leading: Stack(clipBehavior: Clip.none, children: [
              Avatar(
                  name: viewerAccount.account.avatar ??
                      viewerAccount.account.name,
                  size: 28,
                  onTap: () {
                    onPressed();
                  }),
              Positioned(
                bottom: 0,
                right: -6,
                child:
                    viewerAccount.account.vip ? VipIcon() : SizedBox.shrink(),
              )
            ]),
            title: Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Flexible(
                              child: Text(viewerAccount.account.name,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          LikeCount(
                              count: viewerAccount.account.like_count,
                              iconSize: 14,
                              fontSize: 14,
                              backgroundColor: Colors.transparent),
                        ]),
                      ),
                      SizedBox(width: 15),
                      Text(times + "times".tr,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 16)),
                    ])),
            subtitle: Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Last_visit: ".tr + updatedAt,
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor)),
                    ])),
          ),
          !isLast ? Divider(height: 1) : SizedBox.shrink()
        ]));
  }
}
