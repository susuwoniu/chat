import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:get/get.dart';
import '../../post/controllers/post_controller.dart';

class AnswerView extends GetView<PostController> {
  final id = Get.arguments['id'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('AnswerView'),
          centerTitle: true,
        ),
        body: Obx(
          () => Center(
            child: Container(
                width: MediaQuery.of(context).size.width,
                color:
                    HexColor(controller.postTemplatesMap[id]!.backgroundColor),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Text(
                        controller.postTemplatesMap[id]!.content,
                        style: TextStyle(fontSize: 26.0, color: Colors.white),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width * 0.88,
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 4,
                          style: TextStyle(fontSize: 26.0, color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.only(right: 1),
                        height: 40,
                        alignment: Alignment.topRight,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                            color: Colors.white,
                            iconSize: 26,
                            icon: const Icon(Icons.send),
                            padding: const EdgeInsets.all(0),
                            onPressed: () => {})),
                  ],
                )),
          ),
        ));
  }
}
