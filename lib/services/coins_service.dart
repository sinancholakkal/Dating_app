import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/services/auth_services.dart';

class CoinsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'coins';


  Future<void> addCoins({required String userId, required int coins}) async {
    try {
      final docRef = _firestore.collection(_collectionName).doc(userId);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        
        if (doc.exists) {
          // User has existing coins, add to current amount
          final currentCoins = doc.data()?['coins'] ?? 0;
          final newTotal = currentCoins + coins;
          transaction.update(docRef, {'coins': newTotal});
        } else {
          // User doesn't have coins document, create new one
          transaction.set(docRef, {
            'userId': userId,
            'coins': coins,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to add coins: $e');
    }
  }

  /// Get user's current coin balance
  Future<int> getUserCoins({required String userId}) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(userId).get();
      
      if (doc.exists) {
        return doc.data()?['coins'] ?? 0;
      } else {
        // User doesn't have coins document, return 0
        return 0;
      }
    } catch (e) {
      throw Exception('Failed to get user coins: $e');
    }
  }

 

  
}