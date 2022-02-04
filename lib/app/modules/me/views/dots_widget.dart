import 'package:flutter/material.dart';

@immutable
class DotsWidget extends StatelessWidget {
  final int current;
  final int count;
  final Function(int index) onTap;
  final double? size;

  DotsWidget({
    Key? key,
    required this.current,
    required this.count,
    required this.onTap,
    this.size = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List fixedList = Iterable<int>.generate(count).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: fixedList.map((index) {
        return GestureDetector(
            onTap: () => {onTap(index)},
            child: Container(
              width: size,
              height: size,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).colorScheme.onPrimary)
                      .withOpacity(current == index ? 0.9 : 0.4)),
            ));
      }).toList(),
    );
  }
}
