import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImage = false;
  // Pick Image
  Future<File?> pickImage() async {
    if (_isPickingImage) return null; // Prevent multiple calls
    _isPickingImage = true;

    try {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          return File(pickedFile.path);
        }
      } else {
        print("Permission denied");
      }
    } catch (e) {
      print("Error picking image: $e");
    } finally {
      _isPickingImage = false; // Reset the flag
    }

    return null;
  }

  // Upload Image to Firebase Storage
  Future<String?> uploadImage(File imageFile, String productId) async {
    try {
      final ref = _storage.ref().child('product_images/$productId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL(); // Return image URL
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
