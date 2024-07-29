import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

Future<File?> selectVideo() async {
  ImagePicker imagePicker = ImagePicker();
  try {
    XFile? video = await imagePicker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      File videoFile = File(video.path);
      File? compressedVideo = await compressVideo(videoFile);
      return compressedVideo;
    }
  } catch (e) {
    print('Error selecting video: $e');
  }
  return null;
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

Future<File?> compressVideo(File videoFile) async {
  try {
    final info = await VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.MediumQuality, // Adjust quality as needed
      deleteOrigin: false,
    );
    return info?.file;
  } catch (e) {
    print('Error compressing video: $e');
    return null;
  }
}

