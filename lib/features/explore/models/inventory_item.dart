import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final num price;
  final String? imageUrl;

  InventoryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.price,
    this.imageUrl,
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
      imageUrl: data['imageUrl'],
    );
  }
}
