import 'package:flutter/material.dart';

class Templates extends StatelessWidget {
  final String question;
  final String id;
  final Function(String text)? onChanged;
  final bool autofocus;
  final bool enabled;

  Templates(
      {Key? key,
      required this.question,
      required this.id,
      this.onChanged,
      this.autofocus = false,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _marginWidth = _width * 0.07;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _marginWidth),
      child: Column(children: [
        SizedBox(height: 25),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            question,
            style: TextStyle(
                fontSize: 22.0, color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        Container(
          width: _width * 0.88,
          child: TextField(
            autofocus: autofocus,
            enabled: enabled,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 4,
            style: TextStyle(
                fontSize: 26.0, color: Theme.of(context).colorScheme.onPrimary),
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary, width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary, width: 2),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary, width: 2),
              ),
            ),
            onChanged: (String text) {
              if (onChanged != null) {
                onChanged!(text);
              }
            },
            // MOD
          ),
        ),
      ]),
    );
  }
}
