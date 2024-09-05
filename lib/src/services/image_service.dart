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
}
