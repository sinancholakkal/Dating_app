import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/request_model.dart';
import 'package:dating_app/services/auth_services.dart';

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
          senderImageUrl: val['image']??"",
        );
        requestModels.add(model);
      }
      
      return requestModels;
    } catch (e) {
      log("Somthing issue while fetch requests $e");
      throw "$e";
    }
  }
}
