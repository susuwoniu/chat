import 'package:chat/app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final LanMap = {'en': 'English', 'zh': 'Simplified-Chinese'.tr};

class LanRow extends StatelessWidget {
  final BuildContext context;
  final String lanCode;

  LanRow({
    Key? key,
    required this.context,
    required this.lanCode,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isSelected = ConfigProvider.to.locale.value.languageCode == lanCode;
    final conCode = lanCode == 'zh' ? 'CN' : 'US';
    final Locale locale = Locale(lanCode, conCode);
    final text = LanMap[lanCode]!;

    return ListTile(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(text, style: TextStyle(fontSize: 18)),
            isSelected
                ? Icon(
                    Icons.check_outlined,
                    size: 24,
                    color: Color(0xFF7371fc),
                  )
                : SizedBox.shrink(),
          ]),
        ),
        onTap: () {
          if (!isSelected) {
            ConfigProvider.to.onLocaleUpdate(locale);
          }
          Navigator.pop(context);
        });
  }
}
