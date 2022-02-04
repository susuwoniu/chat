import 'package:flutter/material.dart';
import 'dart:io';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

// import 'package:csc_picker/csc_picker.dart';

class Test2View extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _MyHomePageState extends State<Test2View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('test2'),
        ),
        body: Scaffold(
          body: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: TabBar(
              indicatorColor: Colors.green,
              tabs: [
                Tab(
                  text: "Home",
                ),
                Tab(
                  text: "Work",
                ),
              ],
              labelColor: Theme.of(context).colorScheme.onBackground,
              indicator: DotIndicator(
                color: Colors.red,
                distanceFromCenter: 16,
                radius: 3,
                paintingStyle: PaintingStyle.fill,
              ),
            ),
          ),
        ));
  }
}
