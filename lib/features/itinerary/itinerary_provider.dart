import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelanatolia/features/explore/models/inventory_item.dart';

final itineraryProvider = StreamProvider<List<InventoryItem>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('itinerary')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => InventoryItem.fromFirestore(doc)).toList();
  });
});

final itineraryActionsProvider = Provider<ItineraryActions>((ref) {
  return ItineraryActions();
});

class ItineraryActions {
  Future<void> addToItinerary(InventoryItem item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('itinerary')
        .doc(item.id);

    await docRef.set({
      'title': item.title,
      'description': item.description,
      'category': item.category,
      'location': item.location,
      'price': item.price,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFromItinerary(String itemId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('itinerary')
        .doc(itemId)
        .delete();
  }
}
