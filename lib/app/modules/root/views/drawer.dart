import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 100,
            color: Colors.red,
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Get.rootDelegate.toNamed(Routes.HOME);
              //to close the drawer

              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Post'),
            onTap: () {
              Get.rootDelegate.toNamed(Routes.POST);
              //to close the drawer

              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Message'),
            onTap: () {
              Get.rootDelegate.toNamed(Routes.MESSAGE);
              //to close the drawer

              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('splash'),
            onTap: () {
              Get.rootDelegate.toNamed(Routes.SPLASH);
              //to close the drawer

              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Test1'),
            onTap: () {
              Get.rootDelegate.toNamed(Routes.TEST1);
              //to close the drawer

              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Test2'),
            onTap: () {
              Get.rootDelegate.toNamed(Routes.TEST2);
              //to close the drawer

              Navigator.of(context).pop();
            },
          ),
          if (AuthService.to.isLoggedInValue)
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: () {
                AuthService.to.logout();

                Navigator.of(context).pop();
              },
            ),
          if (!AuthService.to.isLoggedInValue)
            ListTile(
              title: Text(
                'Login',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                Get.rootDelegate.toNamed(Routes.LOGIN);
                //to close the drawer

                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
