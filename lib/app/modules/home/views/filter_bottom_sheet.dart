import 'package:chat/app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:chat/common.dart';
import 'vip_sheet.dart';
import 'package:get/get.dart';

final genderMap = {'all': 'All', 'male': 'Male', 'female': 'Female'};

class FilterBottomSheet extends StatefulWidget {
  final BuildContext context;
  final void Function({
    required int startAge,
    required int endAge,
    required String selectedGender,
    required int endDistance,
  }) onSubmitted;
  final String? initialGender;
  final int? initialStartAge;
  final int? initialEndAge;
  final int? initialEndDistance;
  final bool isNearby;

  const FilterBottomSheet({
    Key? key,
    required this.onSubmitted,
    required this.context,
    required this.initialGender,
    required this.initialStartAge,
    required this.initialEndAge,
    this.initialEndDistance,
    this.isNearby = false,
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _currentAgeRangeValues;
  late double _currentEndDistance;

  late String selectedGender;

  @override
  void initState() {
    super.initState();
    _currentAgeRangeValues = RangeValues(
        AuthProvider.to.account.value.vip && widget.initialStartAge != null
            ? widget.initialStartAge!.toDouble()
            : DEFAULT_START_AGE.toDouble(),
        AuthProvider.to.account.value.vip && widget.initialEndAge != null
            ? widget.initialEndAge!.toDouble()
            : DEFAULT_END_AGE.toDouble());

    _currentEndDistance =
        AuthProvider.to.account.value.vip && widget.initialEndDistance != null
            ? widget.initialEndDistance!.toDouble()
            : DEFAULT_END_DISTANCE.toDouble();
    selectedGender =
        AuthProvider.to.account.value.vip && widget.initialGender != null
            ? widget.initialGender!
            : 'all';
  }

  bool positive = false;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final _paddingTop4 = _height * 0.04;
    final _paddingTop3 = _height * 0.03;

    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Wrap(children: [
          Container(
              padding: EdgeInsets.only(bottom: _height * 0.05),
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
                  Text('Filter'.tr,
                      style: TextStyle(fontSize: 21, color: Colors.white)),
                  SizedBox(height: 15),
                  Column(children: [
                    Row(children: [
                      _title('age'),
                      Expanded(
                          child: RangeSlider(
                        values: RangeValues(_currentAgeRangeValues.start,
                            _currentAgeRangeValues.end),
                        max: 100,
                        min: 18,
                        divisions: 8,
                        activeColor: Colors.pinkAccent,
                        inactiveColor: Colors.white,
                        labels: RangeLabels(
                          _currentAgeRangeValues.start.toInt().toString() +
                              'years_old'.tr,
                          _currentAgeRangeValues.end.toInt().toString() +
                              'years_old'.tr,
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentAgeRangeValues = values;
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
                          height: 45,
                          current: selectedGender,
                          values: ['all', 'female', 'male'],
                          iconOpacity: 0.2,
                          indicatorSize: Size.fromWidth(100),
                          indicatorType: IndicatorType.roundedRectangle,
                          iconAnimationType: AnimationType.onHover,
                          indicatorAnimationType: AnimationType.onHover,
                          animationDuration: const Duration(milliseconds: 250),
                          iconBuilder: (value, size, active) {
                            return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    genderMap[value]!.tr,
                                    style: TextStyle(
                                        fontSize: 16,
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
                    widget.isNearby
                        ? SizedBox(height: _paddingTop3)
                        : SizedBox.shrink(),
                    widget.isNearby
                        ? Row(children: [
                            _title('location'),
                            Expanded(
                                child: Slider(
                              value: _currentEndDistance.toDouble(),
                              max: 100,
                              min: 0,
                              divisions: 5,
                              activeColor: Colors.lightGreen,
                              inactiveColor: Colors.white,
                              label:
                                  _currentEndDistance.toInt().toString() + 'KM',
                              onChanged: (double value) {
                                setState(() {
                                  _currentEndDistance = value;
                                });
                              },
                            )),
                          ])
                        : SizedBox.shrink(),
                  ]),
                  SizedBox(height: _paddingTop4),
                  Row(children: [
                    _buttons(
                        text: 'Ok',
                        onPressed: () {
                          if (AuthProvider.to.account.value.vip) {
                            if (widget.initialGender == selectedGender &&
                                widget.initialStartAge ==
                                    _currentAgeRangeValues.start &&
                                widget.initialEndAge ==
                                    _currentAgeRangeValues.end &&
                                widget.initialEndDistance ==
                                    _currentEndDistance) {
                              Navigator.pop(context);
                            } else {
                              widget.onSubmitted(
                                  selectedGender: selectedGender,
                                  startAge:
                                      _currentAgeRangeValues.start.round(),
                                  endAge: _currentAgeRangeValues.end.round(),
                                  endDistance: _currentEndDistance.round());
                              UIUtils.toast('Successfully_filtered'.tr);
                              Navigator.pop(context);
                            }
                          } else {
                            Navigator.pop(context);
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                enableDrag: false,
                                builder: (context) {
                                  return VipSheet(context: context, index: 3);
                                });
                          }
                        }),
                    _buttons(
                        text: 'Reset',
                        onPressed: () {
                          setState(() {
                            _currentAgeRangeValues = RangeValues(18, 98);
                            selectedGender = 'all';
                            _currentEndDistance = 100;
                            UIUtils.toast('Successfully_reset'.tr);
                          });
                        }),
                  ])
                ])
              ])),
        ]);
      },
    );
  }

  Widget _title(String text) {
    final titleMap = {'age': 'Age', 'gender': 'Gender', 'location': 'Distance'};
    final _width = MediaQuery.of(context).size.width;
    return Row(children: [
      SizedBox(width: _width * 0.05),
      Text(titleMap[text]!.tr,
          style: TextStyle(fontSize: 17, color: Colors.white)),
      SizedBox(width: 6),
      Icon(Icons.stars_rounded, color: Colors.pink.shade300, size: 22),
    ]);
  }

  Widget _buttons({required String text, required Function onPressed}) {
    final _width = MediaQuery.of(context).size.width;

    return Expanded(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: _width * 0.04),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: text == 'Ok' ? Colors.pinkAccent : Colors.white60),
      child: TextButton(
          style: ButtonStyle(splashFactory: NoSplash.splashFactory),
          onPressed: () {
            onPressed();
          },
          child: Text(text.tr,
              style: TextStyle(
                  color: text == 'Ok' ? Colors.white : Colors.blue,
                  fontSize: 16))),
    ));
  }
}
