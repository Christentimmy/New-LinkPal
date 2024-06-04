import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> selectVideo() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? video = await imagePicker.pickVideo(
    source: ImageSource.gallery,
  );
  if (video != null) {
    return File(video.path);
  }

  return null; //
}
Future<XFile?> selectVideoXFile() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? video = await imagePicker.pickVideo(
    source: ImageSource.gallery,
  );
  if (video != null) {
    return XFile(video.path);
  }

  return null; //
}