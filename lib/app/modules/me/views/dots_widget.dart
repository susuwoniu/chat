import 'package:flutter/material.dart';

@immutable
class DotsWidget extends StatefulWidget {
  final int current;
  final int count;
  final Function(int index) onTap;
  final double? size;
  final int? initialIndex;

  DotsWidget({
    Key? key,
    required this.current,
    required this.count,
    required this.onTap,
    this.initialIndex,
    this.size = 12,
  }) : super(key: key);

  @override
  _DotsWidgetState createState() => _DotsWidgetState();
}

class _DotsWidgetState extends State<DotsWidget> {
  int _index = 0;
  bool isInitial = true;
  @override
  Widget build(BuildContext context) {
    final List fixedList = Iterable<int>.generate(widget.count).toList();
    if (isInitial && widget.initialIndex != null) {
      _index = widget.initialIndex!;
      isInitial = false;
    } else {
      _index = widget.current;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: fixedList.map((index) {
        return GestureDetector(
            onTap: () => {widget.onTap(index)},
            child: Container(
              width: widget.size,
              height: widget.size,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (Colors.white).withOpacity(_index == index ? 0.9 : 0.4)),
            ));
      }).toList(),
    );
  }
}
