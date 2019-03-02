import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadFile(File file, String name) async {
  final ref = FirebaseStorage.instance.ref().child(name);
  final snapshot = await ref.putFile(file).onComplete;
  final url = await snapshot.ref.getDownloadURL();
  return url.toString();
}

void deleteFile(String name) {
  FirebaseStorage.instance.ref().child(name).delete();
}