import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/di/di.dart';
import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/services/auth_services.dart';

class LookingforService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authService = di.get<AuthServices>();
  Future<void>addLookingfor(List<LookingForModel> lookingFor) async {
    try {
      await _firestore.collection('lookingfor').doc(authService.getCurrentUser()!.uid).set({
        'lookingFor': lookingFor.map((e) => e.toJson()).toList(),
      },SetOptions(merge: true));
    } catch (e) {
      log('Error adding lookingfor: $e');
      rethrow;
    }
  }
  Future<List<LookingForModel>> getLookingfor() async {
    try {
      final doc = await _firestore.collection('lookingfor').doc(authService.getCurrentUser()!.uid).get();
      final data = doc.data();
      return LookingForModel.fromJsonList(data?['lookingFor'] ?? []);
    } catch (e) {
      log('Error getting lookingfor: $e');
      rethrow;
    }
  }
  Future<void> updateLookingfor(List<LookingForModel> lookingFor) async {
    try {
      await _firestore.collection('lookingfor').doc(authService.getCurrentUser()!.uid).set({
        'lookingFor': lookingFor.map((e) => e.toJson()).toList(),
      },SetOptions(merge: true));
    } catch (e) {
      log('Error updating lookingfor: $e');
      rethrow;
    }
  }
  Future<bool> isLookingforExists() async {
    try {
      final doc = await _firestore.collection('lookingfor').doc(authService.getCurrentUser()!.uid).get();
      return doc.exists;
    } catch (e) {
      log('Error checking if lookingfor exists: $e');
      rethrow;
    }
  }
}