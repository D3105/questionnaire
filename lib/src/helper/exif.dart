import 'package:exif/exif.dart';

Future<int> getOrientation(List<int> intList) async {
  final exif = await readExifFromBytes(intList);
  print('Image Orientation' + exif['Image Orientation'].values[0].toString());
  return exif['Image Orientation'].values[0];
}
