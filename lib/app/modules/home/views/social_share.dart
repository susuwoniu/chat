import 'package:flutter/material.dart';
import '../../age_picker/views/next_button.dart';

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
          Text('share_to', style: TextStyle(color: Colors.grey.shade700)),
          SizedBox(height: 18),
          Expanded(
              child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
              ])),
          Expanded(
              child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
                _socialButton(
                    icon: Icons.star, text: 'wechat', onPressed: () {}),
              ])),
          NextButton(
              color: Colors.white,
              size: 17,
              height: height * 0.06,
              width: width * 0.89,
              textColor: Colors.black,
              text: 'Cancel',
              borderRadius: 40,
              onPressed: () {}),
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
                color: color ?? Colors.white, shape: BoxShape.circle),
            child: Icon(icon,
                color: color == null ? Colors.black87 : Colors.white),
          ),
          SizedBox(height: 10),
          Text(text,
              style: TextStyle(color: Colors.grey.shade800, fontSize: 13)),
        ]));
  }
}
