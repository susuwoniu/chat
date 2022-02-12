import 'package:mime_type/mime_type.dart';
import 'dart:async';
import 'package:chat/common.dart';
import 'package:flutter/material.dart';
import 'package:chat/utils/upload.dart';
import 'package:chat/app/providers/providers.dart';
import 'dart:io';

Future<ImageEntity?> uploadImage(File file) async {
  UIUtils.showLoading();

  try {
    final bytes = await file.readAsBytes();
    var decodedImage = await decodeImageFromList(bytes);
    final width = decodedImage.width.toDouble();
    final height = decodedImage.height.toDouble();
    final size = bytes.length;
    final mimeType = mime(file.path);

    if (mimeType != null) {
      final slot = await APIProvider.to.post("/account/me/avatar/slot", body: {
        "mime_type": mimeType,
        "size": size,
        "height": height,
        "width": width
      });
      // print(slot);
      final putUrl = slot["meta"]["put_url"];
      final headers = slot["meta"]["headers"] as Map;
      final Map<String, String> newHeaders = {};
      final image = ImageEntity.fromJson(slot["meta"]["image"]);
      for (var key in headers.keys) {
        newHeaders[key] = headers[key];
      }

      await upload(putUrl, file.path, headers: newHeaders, size: size);
      UIUtils.hideLoading();

      return image;
      // final newImage = ImageEntity.fromJson(result['data']['attributes']);

      // save the latest image info
      // await addImg(index, newImage);
    } else {
      UIUtils.hideLoading();

      throw Exception('wrong image type');
    }
  } catch (e) {
    UIUtils.hideLoading();

    UIUtils.showError(e);
  }
}
