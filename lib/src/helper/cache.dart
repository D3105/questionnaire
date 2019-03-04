import 'dart:io';

void clearPhotoCache() {
  Directory(
          '/storage/emulated/0/Android/data/com.d.questionnaire/files/Pictures/')
      .list()
      .forEach((photo) => photo.delete());
}
