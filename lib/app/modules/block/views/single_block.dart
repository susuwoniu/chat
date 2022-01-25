import 'package:chat/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../../profile_viewers/controllers/profile_viewers_controller.dart';
import '../../message/views/time_ago.dart';
import 'package:get/get.dart';
import '../../me/views/age_widget.dart';
import '../../me/views/like_count.dart';
import 'package:intl/intl.dart';

class SingleBlock extends StatelessWidget {
  final Function() onPressed;
  final ViewerEntity viewerAccount;
  final bool isLast;

  SingleBlock({
    Key? key,
    required this.onPressed,
    required this.viewerAccount,
    required this.isLast,
  }) : super(key: key);
  final DateFormat formatter = DateFormat('yyyy-MM-dd  H:mm');

  @override
  Widget build(BuildContext context) {
    final _gender = viewerAccount.account.gender;

    final _genderColor = _gender == 'unknown'
        ? Colors.black12
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
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                          ]),
                        ),
                        SizedBox(width: 15),
                      ])),
              subtitle: Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AgeWidget(
                          age: viewerAccount.account.age.toString(),
                          gender: viewerAccount.account.gender,
                          background: _genderColor,
                          iconSize: 14,
                          fontSize: 13,
                        ),
                        SizedBox(width: 10),
                        LikeCount(
                          count: viewerAccount.account.like_count,
                          iconSize: 14,
                          fontSize: 14,
                          backgroundColor: Colors.black12,
                        ),
                      ])),
              trailing: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 11),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                      child: Text(
                        'Unblock'.tr,
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {}))),
          !isLast ? Divider(height: 1) : SizedBox.shrink()
        ]));
  }
}
