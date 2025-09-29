import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/request_model.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestServices {
  Future<List<RequestModel>> fetchRequests() async {
    List<RequestModel> requestModels = [];
    final currentUserId = AuthService().getCurrentUser()!.uid;
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('user')
          .doc(currentUserId)
          .get();
      final data = docRef.data();
      if (data == null) return requestModels;

      final req = List<Map<String, dynamic>>.from(data['requests'] ?? []);
      log(req.toString());
      for (var val in req) {
        final model = RequestModel(
          senderId: val['senderid'],
          senderName: val['sendername'],
          senderImageUrl: val['image'] ?? "",
        );
        requestModels.add(model);
      }

      return requestModels;
    } catch (e) {
      log("Somthing issue while fetch requests $e");
      throw "$e";
    }
  }

  Future<void> declineRequest({required RequestModel requestModel}) async {
    // Get the ID of the current user (who is declining the request)
    final currentUserId = AuthService().getCurrentUser()!.uid;

    // Get a reference to the current user's document
    final instance = FirebaseFirestore.instance;
    final docRef = instance.collection('user').doc(currentUserId);

    log("Attempting to decline request from ${requestModel.senderId}...");

    try {
      // Run the entire read-modify-write cycle in a transaction
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // 1. READ: Get the latest version of the document inside the transaction
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          // If the document doesn't exist, there's nothing to do.
          throw Exception("User document does not exist!");
        }

        // Get the current requests list (it will be a List<dynamic>)
        final List<dynamic> requests = List.from(
          snapshot.data()?['requests'] ?? [],
        );

        // 2. MODIFY: Create a new list, keeping only the requests
        //    where the senderId does NOT match the one we want to remove.
        final updatedRequests = requests
            .where(
              (requestMap) => requestMap['senderid'] != requestModel.senderId,
            )
            .toList();

        // 3. WRITE: Update the document with the newly filtered list
        transaction.update(docRef, {'requests': updatedRequests});
      });

      log("Successfully declined request and updated document.");
    } catch (e) {
      log("Error during decline transaction: $e");
    }
  }

  // Helper function to create a consistent chat room ID
  String createChatRoomId(String uid1, String uid2) {
    if (uid1.compareTo(uid2) > 0) {
      return '${uid1}_${uid2}';
    } else {
      return '${uid2}_${uid1}';
    }
  }


  Future<void> acceptChatRequest(String otherUserId) async {
  final firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    throw Exception("No user logged in");
  }

  final currentUserId = currentUser.uid;
  final batch = firestore.batch();

  // --- No changes needed here ---
  final chatRoomId = createChatRoomId(currentUserId, otherUserId);
  final chatRoomRef = firestore.collection('chats').doc(chatRoomId);
  batch.set(chatRoomRef, {
    'users': [currentUserId, otherUserId],
    'lastMessage': 'You are now connected!',
    'lastMessageTimestamp': FieldValue.serverTimestamp(),
  });

  // --- THE FIX: Change .update() to .set(..., merge: true) ---
  final currentUserRef = firestore.collection('users').doc(currentUserId);
  batch.set(currentUserRef, { // Use .set instead of .update
    'matches': FieldValue.arrayUnion([otherUserId]),
    'pendingRequests': FieldValue.arrayRemove([otherUserId]),
  }, SetOptions(merge: true)); // Add the merge option

  final otherUserRef = firestore.collection('users').doc(otherUserId);
  batch.set(otherUserRef, { // Use .set instead of .update
    'matches': FieldValue.arrayUnion([currentUserId]),
  }, SetOptions(merge: true)); // Add the merge option
  
  try {
    await batch.commit();
    await removeFromLikeCollection(documentId: otherUserId, likedUserIdToRemove: currentUserId);
    log("Removed from like collection");
    await removeRequestFromUser(currentUserId: currentUserId, userIdToRemove: otherUserId);
    log("Reuest removed from current user");
    log('Successfully accepted request and created chat room.');
  } catch (e) {
    log('Error accepting request: $e');
    rethrow;
  }
}

    //await removeFromLikeCollection(documentId: currentUserId, likedUserIdToRemove: otherUserId);


Future<void> removeRequestFromUser({
  required String currentUserId,
  required String userIdToRemove,
}) async {
  final firestore = FirebaseFirestore.instance;
  final docRef = firestore.collection('users').doc(currentUserId);

  log('Attempting to remove request from user: $userIdToRemove');

  // Use a transaction for a safe read-modify-write operation
  try {
    await firestore.runTransaction((transaction) async {
      // 1. READ: Get the latest version of the document
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("User document does not exist!");
      }

      // Get the current list of requests, defaulting to an empty list
      final List<dynamic> requests = List.from(snapshot.data()?['requests'] ?? []);

      // 2. MODIFY: Remove the map where 'senderid' matches userIdToRemove
      requests.removeWhere((requestMap) {
        // A safe check to ensure the item is a map and has the key
        if (requestMap is Map && requestMap.containsKey('senderid')) {
          return requestMap['senderid'] == userIdToRemove;
        }
        return false;
      });

      // 3. WRITE: Update the document with the modified list
      transaction.update(docRef, {'requests': requests});
    });
    
    log("Successfully removed request.");

  } catch (e) {
    log("Failed to remove request: $e");
    rethrow;
  }
}


  Future<void> removeFromLikeCollection({
    required String
    documentId, // The ID of the document in the 'like' collection
    required String likedUserIdToRemove, // This is your reQuestModel.id
  }) async {
    // Get a reference to the specific 'like' document
    final docRef = FirebaseFirestore.instance
        .collection('like')
        .doc(documentId);

    log(
      "Attempting to remove like for user: $likedUserIdToRemove from doc: $documentId",
    );

    try {
      // A transaction is the safest way to read, modify, and write data
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // 1. READ: Get the document inside the transaction
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception("Document does not exist!");
        }

        // Get the current 'likes' list from the document
        final List<dynamic> likes = List.from(snapshot.data()?['likes'] ?? []);

        // 2. MODIFY: Create a new list, keeping only the maps where
        // 'likedId' does NOT match the ID we want to remove.
        final updatedLikes = likes
            .where((likeMap) => likeMap['likedId'] != likedUserIdToRemove)
            .toList();

        // 3. WRITE: Update the document with the new, filtered list
        transaction.update(docRef, {'likes': updatedLikes});
      });

      log("Successfully removed like and updated document.");
    } catch (e) {
      log("Error during remove like transaction: $e");
      // You might want to rethrow the error to let the UI know it failed.
      // throw e;
    }
  }
}
