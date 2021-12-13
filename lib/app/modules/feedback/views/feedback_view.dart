import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FeedbackView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '如果您在使用软件过程中遇到任何问题，欢迎向我们反馈～我们的微信号是xxxx，邮箱地址是xxxxx。感谢支持～',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
