import 'package:flutter/material.dart';
import 'package:chat/app/routes/app_pages.dart';
import '../../../services/auth_service.dart';

import 'package:get/get.dart';

import '../controllers/debug_controller.dart';

class DebugView extends GetView<DebugController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DebugView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Home'),
            onTap: () {
              Get.toNamed(Routes.HOME);
              //to close the drawer
            },
          ),
          ListTile(
            title: Text('Post'),
            onTap: () {
              Get.toNamed(Routes.POST);
              //to close the drawer
            },
          ),
          ListTile(
            title: Text('Message'),
            onTap: () {
              Get.toNamed(Routes.MESSAGE);
              //to close the drawer
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Get.toNamed(Routes.SETTING);
              //to close the drawer
            },
          ),
          ListTile(
            title: Text('Room'),
            onTap: () {
              Get.toNamed(Routes.ROOM);
              //to close the drawer
            },
          ),
          ListTile(
            title: Text('splash'),
            onTap: () {
              Get.toNamed(Routes.SPLASH);
              //to close the drawer
            },
          ),
          ListTile(
            title: Text('Test1'),
            onTap: () {
              Get.toNamed(Routes.TEST1);
              //to close the drawer
            },
          ),
          ListTile(
            title: Text('Test2'),
            onTap: () {
              Get.toNamed(Routes.TEST2);
              //to close the drawer
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
                Get.toNamed(Routes.LOGIN);
                //to close the drawer
              },
            ),
        ],
      ),
    );
  }
}
