import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:questionnaire/src/helper/exif.dart';
import 'package:questionnaire/src/widgets/exif_transform.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompressedImage extends StatelessWidget {
  final File file;
  final ImageProvider imageProvider;
  final int quality;

  const CompressedImage({Key key, this.file, this.quality, this.imageProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExifTransform>(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.yellow),
          );
        }

        return snapshot.data;
      },
      future: buildImage(context),
    );
  }

  Future<ExifTransform> buildImage(BuildContext context) async {
    final intList = file?.readAsBytesSync() ??
        await providerToIntList(context, imageProvider);
    final orientation = await getOrientation(intList);
    final compressed =
        await FlutterImageCompress.compressWithList(intList, quality: quality);
    final provider = intListToProvider(compressed);
    return ExifTransform(
      child: Image(image: provider),
      exifOrientation: orientation,
    );
  }

  Future<List<int>> providerToIntList(
      BuildContext context, ImageProvider provider) async {
    var info = await getImageInfo(context, provider);
    var data = await info.image.toByteData();
    return data.buffer.asUint8List().toList();
  }

  ImageProvider intListToProvider(List<int> intList) {
    final u8 = Uint8List.fromList(intList);
    return MemoryImage(u8);
  }
}
