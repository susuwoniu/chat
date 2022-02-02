import 'package:chat/app/routes/app_pages.dart';
import 'dart:core';
import 'package:chat/common.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

final InternalLinks = [
  Routes.MY_SINGLE_POST,
];
bool isInternalLink(String link) {
  final uriObj = Uri.parse(link);
  final host = uriObj.scheme + "://" + uriObj.host;
  if (host == MAIN_HOST) {
    if (InternalLinks.contains(uriObj.path)) {
      return true;
    }
  }
  return false;
}

Future<void> openLink(String? href) async {
  if (href != null && isInternalLink(href)) {
    final uriObj = Uri.parse(href);

    Get.toNamed(uriObj.path, arguments: uriObj.queryParameters);
    return;
  }

  if (href != null && await canLaunch(href)) {
    await launch(href);
  }
}
