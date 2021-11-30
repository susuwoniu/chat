import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/test1_controller.dart';

class Test1View extends GetView<Test1Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: controller.indexes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Obx(() {
                        final entity =
                            controller.entities[controller.indexes[index]];

                        return ListTile(
                            title: Text(entity != null
                                ? entity.count.toString()
                                : "empty"));
                      });
                    })),
            // Text(controller.entities["1"]!.count.toString()),
            TextButton(
              onPressed: () {
                controller.increment();
              },
              child: Text('add'),
            ),
            TextButton(
              onPressed: () {
                controller.sort();
              },
              child: Text('随机'),
            ),
          ],
        ),
      )),
    );
  }
}
