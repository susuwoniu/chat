import 'package:chat/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chat/types/types.dart';
import 'package:get/get.dart';
import '../../me/views/age_widget.dart';
import '../../me/views/like_count.dart';
import 'package:intl/intl.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../../me/views/vip_icon.dart';

class SingleLike extends StatelessWidget {
  final SimpleAccountEntity blockAccount;
  final bool isLast;
  final Function onPressedUnblock;
  final String id;
  final bool isBlock;

  SingleLike(
      {Key? key,
      required this.blockAccount,
      required this.id,
      required this.isLast,
      required this.onPressedUnblock,
      this.isBlock = true})
      : super(key: key);
  final DateFormat formatter = DateFormat('yyyy-MM-dd  HH:mm');

  @override
  Widget build(BuildContext context) {
    final _gender = blockAccount.gender;

    final _genderColor = _gender == 'unknown'
        ? Colors.black26
        : _gender == 'female'
            ? Colors.pink.shade300
            : Colors.lightBlue;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 13),
        child: Column(children: [
          ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              leading: Stack(clipBehavior: Clip.none, children: [
                Avatar(
                    name: blockAccount.avatar ?? blockAccount.name,
                    size: 28,
                    onTap: () {
                      Get.toNamed(Routes.OTHER, arguments: {"accountId": id});
                    }),
                Positioned(
                  bottom: 0,
                  right: -6,
                  child: blockAccount.vip ? VipIcon() : SizedBox.shrink(),
                )
              ]),
              title: Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(children: [
                            Flexible(
                                child: Text(blockAccount.name,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.w500))),
                          ]),
                        ),
                      ])),
              subtitle: Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 10),
                            child: AgeWidget(
                              age: blockAccount.age.toString(),
                              gender: blockAccount.gender,
                              background: _genderColor,
                              color: Theme.of(context).colorScheme.onPrimary,
                              iconSize: 14,
                              fontSize: 13,
                            )),
                        LikeCount(
                          count: blockAccount.like_count,
                          iconSize: 14,
                          fontSize: 14,
                          backgroundColor: Colors.black12,
                        ),
                      ])),
              trailing: isBlock
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 11),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextButton(
                          style: ButtonStyle(
                              splashFactory: NoSplash.splashFactory),
                          child: Text(
                            'Unblock'.tr,
                            style: TextStyle(color: Colors.black54),
                          ),
                          onPressed: () {
                            onPressedUnblock();
                          }))
                  : SizedBox.shrink()),
          !isLast ? Divider(height: 1) : SizedBox.shrink()
        ]));
  }
}
