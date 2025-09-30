// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dating_app/models/chat_user_model.dart';

// class ChatService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Stream<List<ChatUserModel>> getChatsStream(String userId) {
//     // 1. Get the stream of the user's chat room documents
//     return _firestore
//         .collection('chats')
//         .where('users', arrayContains: userId)
//         .orderBy('lastMessageTimestamp', descending: true)
//         .snapshots()
//         .asyncMap((chatSnapshot) async {

//       // 2. For each update, get the list of the other users' IDs
//       final otherUserIds = chatSnapshot.docs.map((doc) {
//         final users = List<String>.from(doc['users']);
//         return users.firstWhere((id) => id != userId);
//       }).toList();

//       if (otherUserIds.isEmpty) {
//         return [];
//       }

//       // 3. Fetch all the other users' profile documents in a single query
//       final userProfilesSnapshot = await _firestore
//           .collection('users')
//           .where(FieldPath.documentId, whereIn: otherUserIds)
//           .get();

//       // Create a quick lookup map of userId -> userData
//       final userProfilesMap = {
//         for (var doc in userProfilesSnapshot.docs) doc.id: doc.data()
//       };

//       // 4. Combine the chat data with the user profile data
//       return chatSnapshot.docs.map((chatDoc) {
//         final chatData = chatDoc.data() as Map<String, dynamic>;
//         final otherUserId = List<String>.from(chatData['users']).firstWhere((id) => id != userId);
//         final otherUserData = userProfilesMap[otherUserId];

//         return ChatUserModel(
//           chatRoomId: chatDoc.id,
//           otherUserId: otherUserId,
//           name: otherUserData?['name'] ?? 'Unknown User',
//           imageUrl: otherUserData?['profileImageUrl'] ?? '',
//           lastMessage: chatData['lastMessage'] ?? '',
//           lastMessageTimestamp: (chatData['lastMessageTimestamp'] as Timestamp).toDate(),
//         );
//       }).toList();
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:dating_app/models/chat_user_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Gets a real-time stream of chat rooms for a specific user.
  ///
  /// [userId] is the ID of the user whose chats you want to listen to.
  Stream<List<ChatUserModel>> getChatsStream(String userId) {
    // 1. Get the stream of the user's chat room documents
    
  try{
      return _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .asyncMap((chatSnapshot) async {
          // 2. For each update, get the list of the other users' IDs
          final otherUserIds = chatSnapshot.docs.map((doc) {
            final users = List<String>.from(doc['users']);
            return users.firstWhere((id) => id != userId);
          }).toList();

          if (otherUserIds.isEmpty) {
            return [];
          }

          // 3. Fetch all the other users' profile documents in a SINGLE efficient query
          final userProfilesSnapshot = await _firestore
              .collection('user')
              .where(FieldPath.documentId, whereIn: otherUserIds)
              .get();

          // Create a map for easy lookup of user data by ID
          final userProfilesMap = {
            for (var doc in userProfilesSnapshot.docs) doc.id: doc.data(),
          };

          // 4. Combine the chat data with the user profile data
          return chatSnapshot.docs.map((chatDoc) {
            final chatData = chatDoc.data() as Map<String, dynamic>;
            final otherUserId = List<String>.from(
              chatData['users'],
            ).firstWhere((id) => id != userId);
            final otherUserData = userProfilesMap[otherUserId];

            return ChatUserModel(
              chatRoomId: chatDoc.id,
              otherUserId: otherUserId,
              name: otherUserData?['name'] ?? 'Unknown User',
              imageUrl: otherUserData?['images'][0] ?? '',
              lastMessage: chatData['lastMessage'] ?? '',
              lastMessageTimestamp:
                  (chatData['lastMessageTimestamp'] as Timestamp).toDate(),
            );
          }).toList();
        });
  }catch(e){
    log("something wrong while fetch chats $e");
    return throw "$e";
  }
  }
}
