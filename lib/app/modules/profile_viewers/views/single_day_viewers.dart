import 'package:chat/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../controllers/profile_viewers_controller.dart';

class SingleDayViewers extends StatelessWidget {
  final controller = ProfileViewersController.to;

  final List? accountMap;

  final void Function()? onPressed;

  SingleDayViewers({
    Key? key,
    this.accountMap,
    this.onPressed,
  }) : super(key: key);

  final userList = [];
  @override
  Widget build(BuildContext context) {
    return Column(
        children: userList.map((item) {
      return singleUser(item);
    }).toList());
  }

  Widget singleUser(item) {
    return Row(children: [
      Stack(children: [
        Avatar(name: item['attributes']['viewed_by']),
        Positioned(
          child:
              Icon(Icons.stars_rounded, color: Colors.pink.shade300, size: 24),
        )
      ]),
      Column(children: [
        Text(item['attributes']['viewed_by']),
        Row(children: [Text('👨'), Text('20岁')])
      ]),
    ]);
  }
}
