import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'dart:io';

Future<File?> cropImage(String path,
    {double ratioX = 4, double ratioY = 5}) async {
  File? croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatio: CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
      androidUiSettings: AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        aspectRatioLockEnabled: false,
      ));
  return croppedFile;
}
