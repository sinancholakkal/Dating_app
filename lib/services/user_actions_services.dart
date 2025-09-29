import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/services/auth_services.dart';

class UserActionsServices {
  Future<void> dislikeAction({required String dislikeUserId}) async {
  try {
    final String currentUserId = AuthService().getCurrentUser()!.uid;

    // Get a reference to the document
    final docRef = FirebaseFirestore.instance
        .collection("dislike")
        .doc(currentUserId);

    // FIX: Use .set() with merge:true instead of .update()
    await docRef.set({
      'ids': FieldValue.arrayUnion([dislikeUserId])
    }, SetOptions(merge: true));

    log("Successfully disliked user: $dislikeUserId");

  } catch (e) {
    log("Something issue while dislike action $e");
  }
}
  Future<List<dynamic>>getDislikeusers({required String currentUserId})async{
    final reference = await FirebaseFirestore.instance.collection('dislike').doc(currentUserId).get();
    List<dynamic>dislikeIds = [];
    final data = reference.data();
    // data!.forEach((key,value){
    //   dislikeIds.add(value);
    // });
    if(data!=null){
      dislikeIds.addAll(data["ids"]);
    }
    return dislikeIds;
  }
}
