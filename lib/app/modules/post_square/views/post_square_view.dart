import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/post_square_controller.dart';
import 'package:hexcolor/hexcolor.dart';

class PostSquareView extends GetView<PostSquareController> {
  final _content = Get.arguments['content'];
  final _color = Get.arguments['color'];

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('PostSquareView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                color: HexColor(_color),
                height: _height * 0.25,
              ),
              Positioned(
                  bottom: -_width * 0.1,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(_width * 0.2)),
                      height: _width * 0.2,
                      width: _width * 0.2,
                      child: Icon(
                        Icons.face_outlined,
                        size: _width * 0.13.toDouble(),
                        color: Colors.black54,
                      ))),
            ],
          ),
          SizedBox(height: _width * 0.15),
          Text(_content,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: _width * 0.02),
          Text("3333条回答",
              style: TextStyle(fontSize: 17.0, color: Colors.black54)),
        ],
      )),
    );
  }
}
