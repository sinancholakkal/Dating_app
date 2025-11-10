import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/di/di.dart';
import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/models/user_current_model.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class UserProfileService {
  final authService = di.get<AuthServices>();
  Future<void> userProfileStoring({required UserProfile userProfile}) async {
    List<String> images = [];
    log(userProfile.interests.toString());
    try {
      log(userProfile.id);
      log("user data add service called");
      String selfie = await uploadImageToFirebase(
        File(userProfile.selfieImageUrl!.path),
        userProfile.id,
        true,
      );
      for (var image in userProfile.imageUrls!) {
        images.add(
          await uploadImageToFirebase(File(image.path), userProfile.id, false),
        );
      }
      await FirebaseFirestore.instance
          .collection("user")
          .doc(userProfile.id)
          .set({
            'id': userProfile.id,
            'name': userProfile.name,
            'age': userProfile.age,
            'gender': userProfile.gender,
            'bio': userProfile.bio,
            'images': images,
            'selfie': selfie,
            "isSetupProfile": true,
            'interests': userProfile.interests.toList(),
          }, SetOptions(merge: true));
    } catch (e) {
      log("Something issue while uploading user profile datas $e");
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    required UserCurrentModel userModel,
    required List<String> deleteImages,
  }) async {
    try {
      List<String> images = [];
      for (var img in userModel.images) {
        if (img is String) {
          images.add(img);
        } else {
          images.add(
            await uploadImageToFirebase(
              File(img.path),
              userModel.userId,
              false,
            ),
          );
        }
      }
      for (String img in deleteImages) {
        deleteImageFromFirebase(img);
      }

      await FirebaseFirestore.instance
          .collection("user")
          .doc(userModel.userId)
          .update({
            'bio': userModel.bio,
            'images': images,
            'interests': userModel.interests,
            //'lookingFor':userModel.,
          });
    } catch (e) {
      log("Something issue while update user profile datas $e");
    }
  }

  Future<void> deleteImageFromFirebase(String imageUrl) async {
    log("Deleting image from Firebase...");
    try {
      final Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);

      await imageRef.delete();

      log("Image successfully deleted.");
    } catch (e) {
      log('Error deleting image: $e');
    }
  }

  Future<String> uploadImageToFirebase(
    File imageFile,
    String userId,
    bool isSelfie, {
    String? collection,
  }) async {
    log("user image upload service called");
    try {
      final imageSize = await imageFile.length();
      final double fileSizeMB = imageSize / (1024 * 1024);
      log('📷 Original image size: ${fileSizeMB.toStringAsFixed(2)} MB');

      if (fileSizeMB > 1.0) {
        log('Image larger than 1MB, compressing...');
        imageFile = await compressingImage(imageFile);
        final int compressedSize = await imageFile.length();
        log(
          '✅ Compressed image size: ${(compressedSize / (1024 * 1024)).toStringAsFixed(2)} MB',
        );
      }
      final String fileName =
          '${isSelfie ? "selfie" : ""}${DateTime.now().millisecondsSinceEpoch}.jpg';

      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child(collection ?? 'user_photos')
          .child(userId)
          .child(fileName);

      final UploadTask uploadTask = storageReference.putFile(imageFile);

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      log('Error uploading image: $e');
      rethrow;
    }
  }

  Future<File> compressingImage(File file) async {
    final dir = await getTemporaryDirectory();

    // Build a unique temporary file path
    final targetPath =
        '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Perform compression
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50, // adjust 0–100
      minWidth: 1080, // optional, to resize and reduce dimensions
      minHeight: 1080,
      format: CompressFormat.jpeg,
    );

    return File(compressedFile!.path); // returns File?
  }

  Future<UserProfile?> fetchUserProfile({String? userId}) async {
    try {
      userId ??= authService.getCurrentUser()!.uid;
      log("Fetching profile for user: $userId");

      final docSnapshot = await FirebaseFirestore.instance
          .collection("user")
          .doc(userId)
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;

        log("data: $data");
        log("============");
        if (data['name'] == null) {
          log("User not fount");
          return null;
        }
        final userProfile = UserProfile(
          id: data["id"] as String,
          name: data["name"] as String,
          age: data['age'] as String,
          gender: data['gender'] as String,
          bio: data['bio'] as String,

          getImages: List<String>.from(data['images'] ?? []),

          getSelfie: data["selfie"] as String,

          interests: Set<String>.from(data['interests'] ?? []),
        );

        return userProfile;
      } else {
        log("No profile document found for user: $userId");
        return null;
      }
    } catch (e) {
      log("An error occurred while fetching the user profile: $e");
      return null;
    }
  }
}
