import 'package:chat/app/ui_utils/crop_image.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:async';
import 'package:chat/common.dart';
import 'package:flutter/material.dart';
import 'package:chat/utils/upload.dart';
import 'package:chat/app/providers/providers.dart';
import 'dart:io';

Future<String?> uploadImage(File file) async {
  try {
    UIUtils.showLoading();
    final bytes = await file.readAsBytes();
    var decodedImage = await decodeImageFromList(bytes);
    final width = decodedImage.width.toDouble();
    final height = decodedImage.height.toDouble();
    final size = bytes.length;
    final mimeType = mime(file.path);

    if (mimeType != null) {
      final img = ProfileImageEntity(
          mime_type: mimeType,
          url: file.path,
          width: width,
          height: height,
          size: size,
          order: 0,
          thumbtail: ThumbtailEntity(
              height: height,
              width: width,
              url: file.path,
              mime_type: mimeType));
      final slot = await APIProvider.to.post("/account/me/avatar/slot", body: {
        "mime_type": img.mime_type,
        "size": img.size,
        "height": img.height,
        "width": img.width
      });
      // print(slot);
      final putUrl = slot["meta"]["put_url"];
      final getUrl = slot["meta"]["get_url"];
      final headers = slot["meta"]["headers"] as Map;
      final Map<String, String> newHeaders = {};

      for (var key in headers.keys) {
        newHeaders[key] = headers[key];
      }
      await upload(putUrl, img.url, headers: newHeaders, size: img.size);
      UIUtils.hideLoading();

      return getUrl;
      // final newImage = ProfileImageEntity.fromJson(result['data']['attributes']);

      // save the latest image info
      // await addImg(index, newImage);
    } else {
      UIUtils.hideLoading();

      throw Exception('wrong image type');
    }
  } catch (e) {
    UIUtils.showError(e);
  }
}
