import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'dart:io';

Future<File?> cropImage(String path) async {
  File? croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 5),
      androidUiSettings: AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        aspectRatioLockEnabled: false,
      ));
  return croppedFile;
}
