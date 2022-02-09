import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:chat/app/ui_utils/crop_image.dart';

Future<File?> chooseImage() async {
  final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  final imageFile = pickedImage != null ? File(pickedImage.path) : null;
  if (imageFile != null) {
    final cropFile = await cropImage(imageFile.path);
    if (cropFile != null) {
      return cropFile;
    }
  }
}
