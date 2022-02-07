import 'package:flutter/material.dart';
import '../../age_picker/views/next_button.dart';
import 'package:get/get.dart';

class SocialShare extends StatefulWidget {
  @override
  _SocialShareState createState() => _SocialShareState();
}

class _SocialShareState extends State<SocialShare> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Wrap(children: [
      Container(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 30),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(6)),
        height: height * 0.4,
        child: Column(children: [
          Text('share_to',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          SizedBox(height: 18),
          Expanded(
              child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
              ])),
          Expanded(
              child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.local_police, text: 'wechat', onPressed: () {}),
              ])),
          NextButton(text: 'Cancel'.tr, onPressed: () {}),
        ]),
      )
    ]);
  }

  Widget _socialButton(
      {required IconData icon,
      required String text,
      Color? color,
      required Function onPressed}) {
    return GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Column(children: [
          Container(
            width: 45,
            height: 45,
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: color ?? Theme.of(context).colorScheme.onPrimary,
                shape: BoxShape.circle),
            child: Icon(icon,
                color: color == null
                    ? Colors.black87
                    : Theme.of(context).colorScheme.onPrimary),
          ),
          SizedBox(height: 10),
          Text(text,
              style: TextStyle(color: Colors.grey.shade800, fontSize: 13)),
        ]));
  }
}
