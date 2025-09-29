import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/services/user_actions_services.dart';

class HomeUserService {
  Future<List<UserProfile>> fetchAllUsers() async {
    List<UserProfile>userModels = [];
    List<String>dislikeIds =[];
    try{
      final doc = await FirebaseFirestore.instance.collection("user").get();
    final currentUser = AuthService().getCurrentUser()!.uid;
    log("going to fetch dislike id's");
    final disIds = await UserActionsServices().getDislikeusers(currentUserId: currentUser);
    for(var d in disIds){
      if(d is String){
        dislikeIds.add(d);
      }
      
    }
    //dislikeIds.addAll(await UserActionsServices().getDislikeusers(currentUserId: currentUser));
    log("success");
    log("Dislike id's:= $dislikeIds");
    final userDocs = doc.docs;
    for (var user in userDocs) {
      log(user.id);
      if (currentUser != user.id && !dislikeIds.contains(user.id)) {
        final data = user.data();
        log(data['name']);
        final userProfile = UserProfile(
          id: data['id'],
          name: data['name'],
          age: data['age'],
          gender: data['gender'],
          bio: data['bio'],
          interests: Set<String>.from(data['interests'] ?? []),
          getImages: List<String>.from(data['images'] ?? [])

        );
        userModels.add(userProfile);
      }
    }
    log(userModels.length.toString());
    return userModels;
    }catch(e){
      log("Something issue while fetching all users data $e");
      throw "$e";
    }
  }
}
