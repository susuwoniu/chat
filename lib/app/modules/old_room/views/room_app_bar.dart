import 'package:flutter/material.dart';

AppBar roomAppBar(BuildContext context, String st) {
  return AppBar(
      leadingWidth: 30,
      title: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 15, 5),
          child: Flex(direction: Axis.horizontal, children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () async {},
                    child: CircleAvatar(radius: 22),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(st),
                )),
            Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      child: Text("💗",
                          style: Theme.of(context).textTheme.headline6),
                      onPressed: () {},
                    ))),
          ])));
}
