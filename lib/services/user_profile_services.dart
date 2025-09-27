import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfileServices {
  Future<void> userProfileStoring({required UserProfile userProfile}) async {
    List<String> images = [];
    log(userProfile.interests.toString());
    try {
      log(userProfile.id);
      log("user data add service called");
      String selfie = await uploadImageToFirebase(
        File(userProfile.selfieImageUrl.path),
        userProfile.id,
        true
      );
      for (var image in userProfile.imageUrls) {
        images.add(
          await uploadImageToFirebase(File(image.path), userProfile.id,false),
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

  Future<String> uploadImageToFirebase(File imageFile, String userId,bool isSelfie) async {
    log("user image upload service called");
    try {
      final String fileName =
          '${isSelfie?"selfie":""}${DateTime.now().millisecondsSinceEpoch}.jpg';

      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_photos')
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
}
