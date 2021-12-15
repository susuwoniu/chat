import 'package:flutter/material.dart';

mainBottomNavigationBar(BuildContext context,
    {required int index, required Function(int index) onTap}) {
  return BottomNavigationBar(
    currentIndex: index,
    elevation: 0,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    backgroundColor: Colors.transparent,
    // backgroundColor: (BottomNavigationBarController.to.page > 0 ||
    //         BottomNavigationBarController.to.backgroundColor.value.isEmpty)
    //     ? Colors.transparent
    //     : Colors.transparent,
    onTap: onTap,
    items: [
      // _Paths.Main + [Empty]
      BottomNavigationBarItem(
          icon: Text("🔥", style: Theme.of(context).textTheme.headline5),
          label: 'Home'),
      // _Paths.Main + Routes.POST

      // _Paths.HOME + _Paths.MESSAGE
      BottomNavigationBarItem(
        icon: Text("👋", style: Theme.of(context).textTheme.headline5),
        label: 'Message',
      ),
      BottomNavigationBarItem(
        icon: Text("😍", style: Theme.of(context).textTheme.headline5),
        label: 'Me',
      ),
    ],
  );
}
