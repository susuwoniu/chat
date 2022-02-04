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
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Stack(children: [
                Positioned(
                  right: 5,
                  top: 0,
                  child: IconButton(
                      icon: Icon(Icons.cancel,
                          color: Theme.of(context).colorScheme.background),
                      iconSize: 32,
                      color: Theme.of(context).colorScheme.background,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(children: [
                      SizedBox(height: _paddingTop3),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Filter'.tr,
                                style: TextStyle(
                                    fontSize: 21,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                            SizedBox(width: 6),
                            Icon(Icons.local_florist,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 25)
                          ]),
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
                            activeColor:
                                Theme.of(context).colorScheme.background,
                            inactiveColor: Theme.of(context).dividerColor,
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
                              iconOpacity: 0.5,
                              indicatorSize: Size.fromWidth(100),
                              indicatorType: IndicatorType.roundedRectangle,
                              iconAnimationType: AnimationType.onHover,
                              indicatorAnimationType: AnimationType.onHover,
                              animationDuration:
                                  const Duration(milliseconds: 250),
                              iconBuilder: (value, size, active) {
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        genderMap[value]!.tr,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                      ),
                                    ]);
                              },
                              borderWidth: 0.0,
                              borderColor: Colors.transparent,
                              colorBuilder: (value) =>
                                  Theme.of(context).colorScheme.onPrimary,
                              onChanged: (value) => setState(() {
                                selectedGender = value;
                              }),
                            ),
                          ),
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
                                  activeColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  inactiveColor:
                                      Theme.of(context).colorScheme.primary,
                                  label:
                                      _currentEndDistance.toInt().toString() +
                                          'KM',
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
                        Expanded(
                            child: TextButton(
                                child: Text('Reset'.tr,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                                onPressed: () {
                                  setState(() {
                                    _currentAgeRangeValues =
                                        RangeValues(18, 98);
                                    selectedGender = 'all';
                                    _currentEndDistance = 100;
                                    UIUtils.toast('Successfully_reset'.tr);
                                  });
                                })),
                        SizedBox(width: 20),
                        Expanded(
                            child: ElevatedButton(
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
                          },
                          child: Text('OK'.tr,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            primary: Theme.of(context).colorScheme.background,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(100), // <-- Radius
                            ),
                          ),
                        )),
                      ])
                    ]))
              ])),
        ]);
      },
    );
  }

  Widget _title(String text) {
    final titleMap = {'age': 'Age', 'gender': 'Gender', 'location': 'Distance'};
    return Row(children: [
      Text(titleMap[text]!.tr,
          style: TextStyle(
              fontSize: 17, color: Theme.of(context).colorScheme.onPrimary)),
    ]);
  }
}
