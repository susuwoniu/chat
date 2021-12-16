import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

const Map<int, String> genderMap = {0: "all", 1: "female", 2: "male"};

class FilterBottomSheet extends StatefulWidget {
  final BuildContext context;
  final void Function(
      {required int startAge,
      required int endAge,
      required String selectedGender}) onSubmitted;

  const FilterBottomSheet(
      {Key? key, required this.onSubmitted, required this.context});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final RangeValues _initialRangeValues = const RangeValues(25, 65);
  RangeValues _currentRangeValues = const RangeValues(25, 65);

  int value = 0;
  String initialGender = 'all';
  bool positive = false;
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
            child: Stack(children: [
              Positioned(
                right: 5,
                top: 0,
                child: IconButton(
                    icon: Icon(Icons.cancel),
                    iconSize: 32,
                    color: Colors.white60,
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
                      values: _initialRangeValues,
                      max: 98,
                      min: 18,
                      divisions: 8,
                      activeColor: Colors.pinkAccent,
                      inactiveColor: Colors.white,
                      labels: RangeLabels(
                        _initialRangeValues.start.round().toString(),
                        _initialRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                        });
                      },
                    )),
                  ]),
                  SizedBox(height: _paddingTop3),
                  Row(children: [
                    _title('gender'),
                    SizedBox(width: 20),
                    Expanded(
                      child: AnimatedToggleSwitch<int>.size(
                        current: value,
                        values: [0, 1, 2],
                        iconOpacity: 0.2,
                        indicatorSize: Size.fromWidth(100),
                        indicatorType: IndicatorType.roundedRectangle,
                        iconAnimationType: AnimationType.onHover,
                        indicatorAnimationType: AnimationType.onHover,
                        iconBuilder: (i, size, active) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  genderMap[i]!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ]);
                        },
                        borderWidth: 0.0,
                        borderColor: Colors.transparent,
                        colorBuilder: (i) => Colors.pink.shade400,
                        onChanged: (i) => setState(() {
                          value = i;
                        }),
                      ),
                    ),
                    SizedBox(width: _width * 0.04),
                  ]),
                ]),
                SizedBox(height: _paddingTop4),
                Row(children: [
                  _buttons(
                      text: 'ok',
                      onPressed: () {
                        if (!AuthProvider.to.account.value.vip) {
                          if (initialGender == genderMap[value] &&
                              _initialRangeValues.start ==
                                  _currentRangeValues.start &&
                              _initialRangeValues.end ==
                                  _currentRangeValues.end) {
                            Navigator.pop(context);
                          } else {
                            widget.onSubmitted(
                              selectedGender: genderMap[value]!,
                              startAge: _currentRangeValues.start.round(),
                              endAge: _currentRangeValues.end.round(),
                            );
                          }
                        } else {
                          UIUtils.showError('not vip');
                        }
                      }),
                  _buttons(text: 'reset', onPressed: () {}),
                ])
              ])
            ]));
      },
    );
  }

  Widget _title(String text) {
    final _width = MediaQuery.of(context).size.width;
    return Row(children: [
      SizedBox(width: _width * 0.05),
      Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
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
