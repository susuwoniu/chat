import 'package:chat/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../controllers/profile_viewers_controller.dart';
import '../../message/views/time_ago.dart';
import 'package:get/get.dart';
import '../../me/views/age_widget.dart';

class SingleViewer extends StatelessWidget {
  final Function() onPressed;
  final ViewerEntity viewerAccount;

  SingleViewer({
    Key? key,
    required this.onPressed,
    required this.viewerAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _paddingTop = MediaQuery.of(context).size.height * 0.015;
    final _gender = viewerAccount.account.gender;
    final _genderBackColor = _gender == 'unknown'
        ? Colors.black12
        : _gender == 'female'
            ? Colors.pink.shade100
            : Colors.blue.shade100;
    final _genderColor = _gender == 'unknown'
        ? Colors.black
        : _gender == 'female'
            ? Colors.pink.shade300
            : Colors.blue;
    return Container(
        padding: EdgeInsets.symmetric(vertical: _paddingTop),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(children: [
          Stack(clipBehavior: Clip.none, children: [
            Avatar(
                name:
                    viewerAccount.account.avatar ?? viewerAccount.account.name,
                size: 30,
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
          SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(
                viewerAccount.account.name,
                style: TextStyle(color: _genderColor, fontSize: 15),
              ),
              SizedBox(width: 2),
              Text(
                "visited_you".tr,
              ),
              SizedBox(width: 3),
              Text(
                viewerAccount.viewedCount.toString(),
                style: TextStyle(color: _genderColor, fontSize: 17),
              ),
              SizedBox(width: 3),
              Text("times".tr),
            ]),
            SizedBox(height: 4),
            AgeWidget(
                gender: _gender,
                age: viewerAccount.account.age.toString(),
                iconSize: 18,
                fontSize: 14,
                background: _genderBackColor),
            SizedBox(height: 4),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text("最近访问: ",
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).hintColor)),
              TimeAgo(updatedAt: viewerAccount.updatedAt),
            ]),
          ]),
        ]));
  }
}
