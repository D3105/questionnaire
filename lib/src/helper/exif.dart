import 'package:exif/exif.dart';

Future<int> getOrientation(List<int> intList) async {
  final exif = await readExifFromBytes(intList);
  return exif['Image Orientation'].values[0];
}
