import 'package:chat/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../controllers/profile_viewers_controller.dart';
import '../../message/views/time_ago.dart';
import 'package:get/get.dart';
import '../../me/views/age_widget.dart';
import '../../me/views/like_count.dart';
import 'package:intl/intl.dart';

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
  final DateFormat formatter = DateFormat('yyyy-MM-dd  H:mm');

  @override
  Widget build(BuildContext context) {
    final String updatedAt =
        formatter.format(DateTime.parse(viewerAccount.updatedAt.toString()));
    final _gender = viewerAccount.account.gender;

    final _genderColor = _gender == 'unknown'
        ? Colors.black
        : _gender == 'female'
            ? Colors.pink.shade300
            : Colors.blue;
    return Container(
        margin: EdgeInsets.fromLTRB(12, 0, 15, 0),
        child: Column(children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 3),
            leading: Stack(clipBehavior: Clip.none, children: [
              Avatar(
                  name: viewerAccount.account.avatar ??
                      viewerAccount.account.name,
                  size: 28,
                  onTap: () {
                    onPressed();
                  }),
              Positioned(
                bottom: -2,
                right: -4,
                child: viewerAccount.account.vip
                    ? Icon(Icons.stars_rounded,
                        color: Colors.pink.shade300, size: 28)
                    : SizedBox.shrink(),
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
                                    color: _genderColor,
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
                      Text(viewerAccount.viewedCount.toString() + "times".tr,
                          style: TextStyle(color: Colors.black, fontSize: 17)),
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
