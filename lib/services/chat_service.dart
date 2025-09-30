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
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  /// [userId] is the ID of the user whose chats you want to listen to.
  Stream<List<ChatUserModel>> getChatsStream(String userId) {

    try {
      return _firestore
          .collection('chats')
          .where('users', arrayContains: userId)
          .orderBy('lastMessageTimestamp', descending: true)
          .snapshots()
          .asyncMap((chatSnapshot) async {
            final otherUserIds = chatSnapshot.docs.map((doc) {
              final users = List<String>.from(doc['users']);
              return users.firstWhere((id) => id != userId);
            }).toList();

            if (otherUserIds.isEmpty) {
              return [];
            }

            final userProfilesSnapshot = await _firestore
                .collection('user')
                .where(FieldPath.documentId, whereIn: otherUserIds)
                .get();

            final userProfilesMap = {
              for (var doc in userProfilesSnapshot.docs) doc.id: doc.data(),
            };

            return chatSnapshot.docs.map((chatDoc) {
              final chatData = chatDoc.data() as Map<String, dynamic>;
              final otherUserId = List<String>.from(
                chatData['users'],
              ).firstWhere((id) => id != userId);
              final otherUserData = userProfilesMap[otherUserId];

              final unreadCountMap =
                  chatData['unreadCount'] as Map<String, dynamic>?;
              final unreadCount = unreadCountMap?[userId] as int? ?? 0;

              return ChatUserModel(
                blockedBy: chatData['blockedBy'] ?? "",
                unreadCount: unreadCount,
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
    } catch (e) {
      log("something wrong while fetch chats $e");
      return throw "$e";
    }
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String messageText,
    required String senderId,
    required String recipientId,
  }) async {
    try {
      
      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add({
            'text': messageText,
            'senderId': senderId,
            'timestamp': FieldValue.serverTimestamp(),
          });

      await _firestore.collection('chats').doc(chatRoomId).update({
        'lastMessage': messageText,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'unreadCount.$recipientId': FieldValue.increment(1),
      });
    } catch (e) {
      log("Error sending message: $e");
      rethrow;
    }
  }

  /// Gets a real-time stream of messages for a specific chat room.
  Stream<QuerySnapshot> getMessagesStream({required String chatRoomId}) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true) 
        .snapshots();
  }

  // In your ChatService
  Future<void> updateUserTypingStatus({
    required String chatRoomId,
    required String userId,
    required bool isTyping,
  }) async {
    final docRef = _firestore.collection('chats').doc(chatRoomId);
    if (isTyping) {
      // Add the user's ID to the array
      await docRef.update({
        'typingUsers': FieldValue.arrayUnion([userId]),
      });
    } else {
      // Remove the user's ID from the array
      await docRef.update({
        'typingUsers': FieldValue.arrayRemove([userId]),
      });
    }
  }

  Future<void> markChatAsRead({
    required String chatRoomId,
    required String currentUserId,
  }) async {
    await _firestore.collection('chats').doc(chatRoomId).update({
      'unreadCount.$currentUserId': 0,
    });
  }

  //Bloc chat---------------------------
  Future<bool> blockChat({
    required String chatRoomId,
    required String currentUserId,
  }) async {
    try {
      final chatRoomRef = _firestore.collection('chats').doc(chatRoomId);
      await chatRoomRef.update({'blockedBy': currentUserId});
      log("Chat room $chatRoomId has been blocked by user $currentUserId");
      return true;
    } catch (e) {
      log("Error blocking chat: $e");
      return false;
    }
  }


  //Unblock chat-----------------
  Future<void> unblockChat({required String chatRoomId}) async {
    try {
      final chatRoomRef = _firestore.collection('chats').doc(chatRoomId);

      await chatRoomRef.update({'blockedBy': ""});

      log("Chat room $chatRoomId has been unblocked.");
    } catch (e) {
      log("Error unblocking chat: $e");
      rethrow;
    }
  }



Future<void> reportUser({
  required String reportedUserId,
  required String reason,
  required String chatRoomId,
}) async {
  final firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    throw Exception("No user is currently logged in.");
  }

  final reportData = {
    'reporterId': currentUser.uid,
    'reportedUserId': reportedUserId,
    'reason': reason,
    'chatRoomId': chatRoomId,
    'timestamp': FieldValue.serverTimestamp(),
    'status': 'pending_review', 
  };

  try {
    
    await firestore.collection('reports').add(reportData);
    log('Successfully submitted report for user: $reportedUserId');
  } catch (e) {
    log('Error submitting report: $e');
    rethrow;
  }
}
}
