import 'package:flutter/material.dart';
import '../../me/views/circle_widget.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class FilterBottomSheet extends StatefulWidget {
  final BuildContext context;

  const FilterBottomSheet({Key? key, required this.context});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _currentRangeValues = const RangeValues(25, 65);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final _paddingTop4 = _height * 0.04;
    final _paddingTop3 = _height * 0.03;
    final _paddingTop1 = _height * 0.01;

    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
            clipBehavior: Clip.hardEdge,
            height: _height * 0.4,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.shade400,
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 10,
                  top: 10,
                  child: CircleWidget(
                      icon: Icon(Icons.close_rounded),
                      height: 32,
                      iconSize: 22,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                Column(children: [
                  SizedBox(height: _paddingTop3),
                  Text('Filter',
                      style: TextStyle(fontSize: 23, color: Colors.white)),
                  SizedBox(height: _paddingTop1),
                  Column(children: [
                    Row(children: [
                      _title('age'),
                      Expanded(
                          child: RangeSlider(
                        values: _currentRangeValues,
                        max: 98,
                        min: 18,
                        divisions: 8,
                        activeColor: Colors.pinkAccent,
                        inactiveColor: Colors.white,
                        labels: RangeLabels(
                          _currentRangeValues.start.round().toString(),
                          _currentRangeValues.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentRangeValues = values;
                          });
                        },
                      )),
                      SizedBox(width: _width * 0.03),
                    ]),
                    SizedBox(height: _paddingTop3),
                    Row(children: [
                      _title('gender'),
                      SizedBox(width: 20),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(right: _width * 0.07),
                                alignment: Alignment.center,
                                height: _height * 0.055,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text('choose gender',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ))),
                    ]),
                  ]),
                  SizedBox(height: _paddingTop4),
                  Row(children: [
                    _buttons(text: 'ok', onPressed: () {}),
                    _buttons(text: 'reset', onPressed: () {}),
                  ])
                ])
              ],
            ));
      },
    );
  }

  Widget _title(String text) {
    final _width = MediaQuery.of(context).size.width;
    return Row(children: [
      SizedBox(width: _width * 0.05),
      Text(text, style: TextStyle(fontSize: 22, color: Colors.white)),
      SizedBox(width: 3),
      Icon(Icons.stars_rounded, color: Colors.pink.shade300, size: 24),
    ]);
  }

  Widget _buttons({required String text, required Function onPressed}) {
    final _width = MediaQuery.of(context).size.width;

    return Expanded(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: _width * 0.04),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: text == 'ok' ? Colors.pinkAccent : Colors.white60),
      child: TextButton(
          onPressed: () {
            onPressed();
          },
          child: Text(text)),
    ));
  }
}
