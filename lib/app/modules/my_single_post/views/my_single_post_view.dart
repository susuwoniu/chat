import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_single_post_controller.dart';

class MySinglePostView extends GetView<MySinglePostController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MySinglePostView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MySinglePostView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
