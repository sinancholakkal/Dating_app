import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SwipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _dailySwipeLimit = 4; // Your limit

  /// Checks if a user can swipe. If they can, it updates their count.
  /// Returns `true` if the swipe is allowed, `false` if the limit is reached.
  // In your SwipeService

Future<bool> canSwipe() async {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final userRef = _firestore.collection('user').doc(currentUserId);

  return _firestore.runTransaction((transaction) async {
    final snapshot = await transaction.get(userRef);
    if (!snapshot.exists) return false;

    final data = snapshot.data()!;
    final int swipeCount = data['dailySwipeCount'] ?? 0;
    
    // --- THE FIX ---
    // 1. Read the timestamp as nullable (Timestamp?) to allow for null values.
    final Timestamp? lastSwipe = data['lastSwipeDate'];

    // 2. If it's null (first swipe ever) or a different day, reset the count.
    bool isNewDay = true;
    if (lastSwipe != null) {
      final String lastSwipeDay = DateFormat('yyyy-MM-dd').format(lastSwipe.toDate());
      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      isNewDay = lastSwipeDay != today;
    }
    
    if (isNewDay) {
      // It's a new day or the user's first ever swipe.
      // Reset the count to 1 and allow the swipe.
      transaction.update(userRef, {
        'dailySwipeCount': 1,
        'lastSwipeDate': FieldValue.serverTimestamp(),
      });
      return true;
    } else {
      // It's the same day, so check the limit.
      if (swipeCount < _dailySwipeLimit) {
        transaction.update(userRef, {
          'dailySwipeCount': FieldValue.increment(1),
          'lastSwipeDate': FieldValue.serverTimestamp(),
        });
        return true;
      } else {
        // Limit reached for today.
        return false;
      }
    }
  });
}
}