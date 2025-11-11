import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/di/di.dart';
import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/services/auth_services.dart';

class TurnOnsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final authService = di.get<AuthServices>();
  Future<void>addTurnOns(List<LookingForModel> turnOns) async {
    try {
      final List<LookingForModel> modelsToSort = List<LookingForModel>.from(turnOns);
      modelsToSort.sort((a, b) {
        return b.isSelected.toString().compareTo(a.isSelected.toString());
      });
      await _firestore.collection('turnons').doc(authService.getCurrentUser()!.uid).set({
        'turnOns': modelsToSort.map((e) => e.toJson()).toList(),
      },SetOptions(merge: true));
    } catch (e) {
      log('Error adding turnOns: $e');
      rethrow;
    }
  }
  Future<List<LookingForModel>> getTurnOns() async {
    try {
      final doc = await _firestore.collection('turnons').doc(authService.getCurrentUser()!.uid).get();
      final data = doc.data();
      return LookingForModel.fromJsonList(data?['turnOns'] ?? []);
    } catch (e) {
      log('Error getting turnOns: $e');
      rethrow;
    }
  }
  Future<void> updateTurnOns(List<LookingForModel> turnOns) async {
    try {
      final List<LookingForModel> modelsToSort = List<LookingForModel>.from(turnOns);
      modelsToSort.sort((a, b) {
        return b.isSelected.toString().compareTo(a.isSelected.toString());
      });
      await _firestore.collection('turnons').doc(authService.getCurrentUser()!.uid).set({
        'turnOns': modelsToSort.map((e) => e.toJson()).toList(),
      },SetOptions(merge: true));
    } catch (e) {
      log('Error updating turnOns: $e');
      rethrow;
    }
  }
  Future<bool> isTurnOnsExists() async {
    try {
      final doc = await _firestore.collection('turnons').doc(authService.getCurrentUser()!.uid).get();
      return doc.exists;
    } catch (e) {
      log('Error checking if turnOns exists: $e');
      rethrow;
    }
  }
}