import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter/foundation.dart';
import 'package:travelanatolia/features/explore/models/inventory_item.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final exploreProvider = StreamProvider<List<InventoryItem>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  debugPrint('Exploring category: $category');
  
  Query query = FirebaseFirestore.instance.collection('inventory');
  
  if (category != 'All') {
    query = query.where('category', isEqualTo: category);
  }

  return query.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => InventoryItem.fromFirestore(doc)).toList();
  });
});

