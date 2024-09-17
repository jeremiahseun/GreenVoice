import 'dart:developer';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker picker = ImagePicker();

  Future<XFile?> pickmage({required bool isGallery}) async {
    try {
      if (isGallery) {
        return await picker.pickImage(source: ImageSource.gallery);
      } else {
        return await picker.pickImage(source: ImageSource.camera);
      }
    } catch (e) {
      return null;
    }
  }

  static Future<XFile?> compressImage(
      {required XFile file, required String path}) async {
    log("Compressing image");
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      path,
      quality: 88,
    );

    log("Done compressing... ${result?.name}");
    return result;
  }
}
