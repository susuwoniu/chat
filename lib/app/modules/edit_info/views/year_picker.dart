import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YearPicker extends StatefulWidget {
  final Function(int year)? onSelect;
  final bool isShowBar;
  final Function(int year)? onChanged;
  const YearPicker(
      {Key? key, this.onSelect, required this.isShowBar, this.onChanged});

  @override
  _YearPickerState createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  int currentYear = DateTime.parse(DateTime.now().toString()).year - 18;

  @override
  void initState() {
    super.initState();
    //初始化状态
    print("initState");
  }

  final List<int> _ageList = List.generate(
      92, (i) => DateTime.parse(DateTime.now().toString()).year - 18 - i,
      growable: false);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Stack(children: [
      Container(
          height: _height * 0.35,
          padding: EdgeInsets.only(top: _height * 0.04),
          color: Colors.white,
          child: GestureDetector(
            // Blocks taps from propagating to the modal sheet and popping.
            onTap: () {},
            child: SafeArea(
              top: false,
              child: CupertinoPicker(
                  squeeze: 1.2,
                  scrollController:
                      FixedExtentScrollController(initialItem: 10),
                  selectionOverlay:
                      const CupertinoPickerDefaultSelectionOverlay(
                          // capLeftEdge: false,
                          // capRightEdge: false
                          ),
                  magnification: 1.4,
                  children: _ageList
                      .map(
                        (e) => Container(
                            alignment: Alignment.center,
                            child: Text(e.toString(),
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                      )
                      .toList(),
                  itemExtent: _height * 0.05,
                  onSelectedItemChanged: (index) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(_ageList[index]);
                    }
                    setState(() {
                      currentYear = _ageList[index];
                    });
                  }),
            ),
          )),
      widget.isShowBar
          ? Container(
              padding: EdgeInsets.only(top: 3),
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                ),
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        if (widget.onSelect != null) {
                          widget.onSelect!(currentYear);
                        }
                      },
                      child: Text(
                        '确认',
                        style: TextStyle(fontSize: 16),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: 28,
                      )),
                ],
              ),
            )
          : SizedBox.shrink(),
    ]);
  }
}
