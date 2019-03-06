import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File> pickImageFrom(ImageSource source) {
  return ImagePicker.pickImage(source: source, maxWidth: 500, maxHeight: 500);
}
