import 'package:flutter/material.dart';

class SigninButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final void Function() onPressed;

  const SigninButton({
    Key? key,
    required this.child,
    this.width = double.infinity,
    this.height = 50.0,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        // gradient: LinearGradient(
        //   colors: <Color>[
        //     Theme.of(context).colorScheme.primaryVariant,
        //     Theme.of(context).colorScheme.primary,
        //   ],
        // ),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onPressed,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
