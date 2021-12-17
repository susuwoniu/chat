import 'package:chat/app/providers/auth_provider.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:chat/common.dart';

class FilterBottomSheet extends StatefulWidget {
  final BuildContext context;
  final void Function(
      {required int startAge,
      required int endAge,
      required String selectedGender}) onSubmitted;
  final String? initialGender;
  final int? initialStartAge;
  final int? initialEndAge;

  const FilterBottomSheet({
    Key? key,
    required this.onSubmitted,
    required this.context,
    required this.initialGender,
    required this.initialStartAge,
    required this.initialEndAge,
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _currentRangeValues;
  late String selectedGender;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(
        widget.initialStartAge != null
            ? widget.initialStartAge!.toDouble()
            : DEFAULT_START_AGE.toDouble(),
        widget.initialEndAge != null
            ? widget.initialEndAge!.toDouble()
            : DEFAULT_END_AGE.toDouble());
    selectedGender = widget.initialGender ?? 'all';
  }

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
                      values: RangeValues(
                          _currentRangeValues.start, _currentRangeValues.end),
                      max: 98,
                      min: 18,
                      divisions: 8,
                      activeColor: Colors.pinkAccent,
                      inactiveColor: Colors.white,
                      labels: RangeLabels(
                        _currentRangeValues.start.toString(),
                        _currentRangeValues.end.toString(),
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
                      child: AnimatedToggleSwitch<String>.size(
                        current: selectedGender,
                        values: ['all', 'female', 'male'],
                        iconOpacity: 0.2,
                        indicatorSize: Size.fromWidth(100),
                        indicatorType: IndicatorType.roundedRectangle,
                        iconAnimationType: AnimationType.onHover,
                        indicatorAnimationType: AnimationType.onHover,
                        iconBuilder: (value, size, active) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ]);
                        },
                        borderWidth: 0.0,
                        borderColor: Colors.transparent,
                        colorBuilder: (value) => Colors.pink.shade400,
                        onChanged: (value) => setState(() {
                          selectedGender = value;
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
                          if (widget.initialGender == selectedGender &&
                              widget.initialStartAge ==
                                  _currentRangeValues.start &&
                              widget.initialEndAge == _currentRangeValues.end) {
                            Navigator.pop(context);
                            UIUtils.toast('ok');
                          } else {
                            widget.onSubmitted(
                              selectedGender: selectedGender,
                              startAge: _currentRangeValues.start.round(),
                              endAge: _currentRangeValues.end.round(),
                            );
                            Navigator.pop(context);
                            UIUtils.toast('okkkk');
                          }
                        } else {
                          UIUtils.showError('not vip');
                        }
                      }),
                  _buttons(
                      text: 'reset',
                      onPressed: () {
                        setState(() {
                          _currentRangeValues = RangeValues(18, 98);
                          selectedGender = 'all';
                        });
                      }),
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
