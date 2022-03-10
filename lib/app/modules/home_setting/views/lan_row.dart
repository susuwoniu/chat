import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final LanMap = {'en': 'English', 'zh': 'Simplified-Chinese'.tr};
final _lan = ['English', 'Simplified-Chinese'.tr];
final _title = ['en', 'zh'];

class LanRow extends StatelessWidget {
  final String current;

  LanRow({
    Key? key,
    required this.current,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.separated(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _lan.length,
            itemBuilder: (BuildContext context, int index) {
              final isSelected = current == _title[index];
              final conCode = LanMap[current];
              final Locale locale = Locale(_title[index], conCode);
              return ListTile(
                  title: Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                    child: Text(_lan[index], style: TextStyle(fontSize: 18)),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_outlined,
                          size: 24,
                          color: Color(0xFF7371fc),
                        )
                      : SizedBox.shrink(),
                  onTap: () {
                    if (!isSelected) {
                      ConfigProvider.to.onLocaleUpdate(locale);
                    }
                    Navigator.pop(context);
                  });
            },
            separatorBuilder: (BuildContext context, int index) =>
                Divider(height: 1)));
  }
}
