import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final storage = FirebaseStorage.instance;

//* Upload user picture
  Future<(bool status, String? message, String path)> uploadUserPicture({
    required File image,
    required String userId,
    required String username,
  }) async {
    try {
      final passportRef = storage.ref().child('users/$userId/$username.jpg');
      await passportRef.putFile(image);
      final pictureUrl = await passportRef.getDownloadURL();
      return (true, "Picture uploaded successfully", pictureUrl);
    } on FirebaseException catch (e) {
      return (false, e.message, "");
    } catch (e) {
      return (false, e.toString(), "");
    }
  }

//* Upload issues
  Future<(bool status, String? message, List<String> path)> uploadIssuePicture(
      {required List<File> image,
      required String userId,
      required String folderPath,
      required Function(int) uploadProgress}) async {
    try {
      List<String> imagesUrl = [];

      for (var i = 0; i < image.length; i++) {
        final element = image[i];
        uploadProgress(i + 1);
        final passportRef = storage
            .ref()
            .child('issues/$folderPath/${DateTime.now().microsecondsSinceEpoch}.jpg');
        await passportRef.putFile(element);
        final pictureUrl = await passportRef.getDownloadURL();
        imagesUrl.add(pictureUrl);
      }
      return (true, "Picture uploaded successfully", imagesUrl);
    } on FirebaseException catch (e) {
      return (false, e.message, <String>[]);
    } catch (e) {
      return (false, e.toString(), <String>[]);
    }
  }

//* Upload projects
  Future<(bool status, String? message, List<String> path)> uploadProjectPicture(
      {required List<File> image,
      required String userId,
      required String folderPath,
      required Function(int) uploadProgress}) async {
    try {
      List<String> imagesUrl = [];

      for (var i = 0; i < image.length; i++) {
        final element = image[i];
        uploadProgress(i + 1);
        final passportRef = storage
            .ref()
            .child('projects/$folderPath/${DateTime.now().microsecondsSinceEpoch}.jpg');
        await passportRef.putFile(element);
        final pictureUrl = await passportRef.getDownloadURL();
        imagesUrl.add(pictureUrl);
      }
      return (true, "Picture uploaded successfully", imagesUrl);
    } on FirebaseException catch (e) {
      return (false, e.message, <String>[]);
    } catch (e) {
      return (false, e.toString(), <String>[]);
    }
  }
}
