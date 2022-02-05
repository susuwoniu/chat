import 'package:chat/common.dart';
import 'package:flutter/material.dart';
import 'package:chat/app/widgets/badge.dart';

mainBottomNavigationBar(BuildContext context,
    {required int index,
    required int messageNotificationCount,
    required Function(int index) onTap}) {
  return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Container(
          decoration: index == 0
              ? null
              : BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  )
                ]),
          child: BottomNavigationBar(
            currentIndex: index,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: index == 0
                ? Colors.transparent
                : Theme.of(context).colorScheme.surface,
            onTap: onTap,
            items: [
              // _Paths.Main + [Empty]
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_rounded,
                  size: 36,
                  color: index == 0 ? Colors.white : null,
                ),
                label: 'Home',
              ),
              // _Paths.Main + Routes.POST

              // _Paths.HOME + _Paths.MESSAGE
              BottomNavigationBarItem(
                icon: Badge(
                    notificationCount: messageNotificationCount,
                    iconData: Icons.chat_bubble_rounded,
                    color: index == 0 ? Color(0xff706F73) : null),
                label: 'Message',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.face_rounded,
                    size: 34, color: index == 0 ? Color(0xff706F73) : null),
                label: 'Me',
              )
            ],
          )));
}
