import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YearPicker extends StatefulWidget {
  final Function(int year)? onSelect;
  final bool isShowBar;
  final int initialYear;
  final Function(int year)? onChanged;
  const YearPicker(
      {Key? key,
      this.onSelect,
      required this.isShowBar,
      this.onChanged,
      this.initialYear = 1998});

  @override
  _YearPickerState createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  int currentYear = DateTime.parse(DateTime.now().toString()).year - 24;

  @override
  void initState() {
    super.initState();
  }

  final List<int> _ageList = List.generate(
      92, (i) => DateTime.parse(DateTime.now().toString()).year - 18 - i,
      growable: false);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Wrap(children: [
      widget.isShowBar
          ? Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                    bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).colorScheme.onBackground,
                        size: 28,
                      )),
                  TextButton(
                      onPressed: () {
                        if (widget.onSelect != null) {
                          widget.onSelect!(currentYear);
                        }
                      },
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                      child: Text(
                        'Save'.tr,
                        style: TextStyle(fontSize: 16),
                      )),
                ],
              ),
            )
          : SizedBox.shrink(),
      Container(
        height: _height * 0.35,
        alignment: Alignment.center,
        child: CupertinoPicker(
            backgroundColor: Theme.of(context).colorScheme.background,
            squeeze: 1.2,
            scrollController: FixedExtentScrollController(initialItem: 6),
            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                // capLeftEdge: false,
                // capRightEdge: false
                ),
            magnification: 1.3,
            children: _ageList
                .map(
                  (e) => Container(
                      alignment: Alignment.center,
                      child: Text(e.toString(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w500))),
                )
                .toList(),
            itemExtent: 45,
            onSelectedItemChanged: (index) {
              if (widget.onChanged != null) {
                widget.onChanged!(_ageList[index]);
              }
              setState(() {
                currentYear = _ageList[index];
              });
            }),
      ),
    ]);
  }
}
