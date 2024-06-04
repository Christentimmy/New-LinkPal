import 'package:image_picker/image_picker.dart';

selectImage() async {
  ImagePicker imagePicker = ImagePicker();

  XFile? image = await imagePicker.pickImage(
    source: ImageSource.gallery,
  );
  if (image != null) {
    return image.readAsBytes();
  }
}

Future<XFile?> selectImageInFileFormat() async {
  ImagePicker imagePicker = ImagePicker();

  XFile? image = await imagePicker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 50,
  );

  if (image != null) {
    return XFile(image.path);
  }
  return null;
}

