import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:get/get.dart';

class NearbySwitch extends StatefulWidget {
  final Function onPressedTabSwitch;
  final String? selectedPage;

  const NearbySwitch({
    Key? key,
    required this.onPressedTabSwitch,
    this.selectedPage,
  });
  @override
  _NearbySwitchState createState() => _NearbySwitchState();
}

class _NearbySwitchState extends State<NearbySwitch> {
  late String page;

  @override
  void initState() {
    super.initState();

    page = widget.selectedPage ?? 'Home';
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return AnimatedToggleSwitch<String>.size(
      height: 38,
      innerColor: Colors.white24,
      current: page,
      values: ["Home", 'Nearby'],
      iconOpacity: 0.8,
      indicatorSize: Size.fromWidth(_width * 0.2),
      indicatorType: IndicatorType.roundedRectangle,
      iconAnimationType: AnimationType.onHover,
      indicatorAnimationType: AnimationType.onHover,
      animationDuration: const Duration(milliseconds: 300),
      iconBuilder: (value, size, active) {
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            value.tr,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ]);
      },
      borderWidth: 0.0,
      borderColor: Colors.transparent,
      colorBuilder: (value) => Colors.white30,
      onChanged: (value) => setState(() {
        page = value;
        widget.onPressedTabSwitch(value);
      }),
    );
  }
}
