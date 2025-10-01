import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SwipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _dailySwipeLimit = 4; // Your limit


Future<bool> canSwipe() async {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final userRef = _firestore.collection('user').doc(currentUserId);

  return _firestore.runTransaction((transaction) async {
    final snapshot = await transaction.get(userRef);
    if (!snapshot.exists) return false;

    final data = snapshot.data()!;
    final int swipeCount = data['dailySwipeCount'] ?? 0;
    
    final Timestamp? lastSwipe = data['lastSwipeDate'];

    bool isNewDay = true;
    if (lastSwipe != null) {
      final String lastSwipeDay = DateFormat('yyyy-MM-dd').format(lastSwipe.toDate());
      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      isNewDay = lastSwipeDay != today;
    }
    
    if (isNewDay) {
      transaction.update(userRef, {
        'dailySwipeCount': 1,
        'lastSwipeDate': FieldValue.serverTimestamp(),
      });
      return true;
    } else {
      if (swipeCount < _dailySwipeLimit) {
        transaction.update(userRef, {
          'dailySwipeCount': FieldValue.increment(1),
          'lastSwipeDate': FieldValue.serverTimestamp(),
        });
        return true;
      } else {
        return false;
      }
    }
  });
}
}