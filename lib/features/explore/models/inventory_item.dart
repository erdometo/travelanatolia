import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final num price;

  InventoryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.price,
  });

  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InventoryItem(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      price: data['price'] ?? 0,
    );
  }
}
