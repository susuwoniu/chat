import 'package:flutter/material.dart';

mainBottomNavigationBar(BuildContext context,
    {required int index, required Function(int index) onTap}) {
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
            backgroundColor: index == 0 ? Colors.transparent : Colors.white,
            onTap: onTap,
            items: [
              // _Paths.Main + [Empty]
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 35),
                label: 'Home',
              ),
              // _Paths.Main + Routes.POST

              // _Paths.HOME + _Paths.MESSAGE
              BottomNavigationBarItem(
                icon: Icon(Icons.mark_chat_unread_rounded, size: 30),
                label: 'Message',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.face_rounded, size: 34),
                label: 'Me',
              )
            ],
          )));
}
