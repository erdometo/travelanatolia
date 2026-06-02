import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelanatolia/ui/theme.dart';
import 'package:travelanatolia/features/explore/explore_provider.dart';
import 'package:travelanatolia/features/explore/models/inventory_item.dart';
import 'package:travelanatolia/features/itinerary/itinerary_provider.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final exploreState = ref.watch(exploreProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Elegant Header
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Text(
                'Discover',
                style: theme.textTheme.headlineLarge,
              ),
              background: Container(color: AppColors.background),
            ),
            actions: [
              if (kDebugMode)
                IconButton(
                  icon: const Icon(LucideIcons.databaseBackup, color: AppColors.primary),
                  onPressed: () async {
                    try {
                      await _seedDatabase(context);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('World populated locally.')),
                        );
                      }
                    } catch (e) {
                      debugPrint('Seed Error: $e');
                    }
                  },
                ),
              const Padding(
                padding: EdgeInsets.only(right: 24),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=traveler'),
                ),
              ),
            ],
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildCategories(ref),
            ),
          ),

          // Bento Grid
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: exploreState.when(
              data: (items) {
                if (items.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text("Seek and you shall find.")),
                  );
                }
                return SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemBuilder: (context, index) {
                    return _DiscoveryCard(item: items[index]);
                  },
                  childCount: items.length,
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => SliverFillRemaining(
                child: Center(child: Text('Disturbance in the network: $e')),
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildCategories(WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categories = ['All', 'Fine Dining', 'Run Clubs', 'Boutique Hotels', 'Workshops', 'Tours'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: categories.map((cat) {
          final isSelected = cat == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (val) {
                ref.read(selectedCategoryProvider.notifier).state = cat;
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              side: BorderSide(color: isSelected ? AppColors.primary : AppColors.outlineVariant),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _seedDatabase(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    final List<Map<String, dynamic>> experiences = [
      {
        'id': 'exp_balloon_cappadocia',
        'title': 'Cappadocia Hot Air Balloon Flight',
        'description': 'Float gently over Cappadocia\'s fairy chimneys at sunrise. Experience a panoramic 360-degree view of the dramatic rock formations followed by a traditional champagne toast.',
        'category': 'Tours',
        'location': 'Göreme, Cappadocia',
        'price': 250,
        'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&q=80&w=600',
      },
      {
        'id': 'exp_goreme_museum',
        'title': 'Göreme Open-Air Museum Cave Church Tour',
        'description': 'Explore a vast monastic complex of rock-cut churches, chapels, and monasteries, featuring beautifully preserved Byzantine frescoes dating from the 10th to 12th centuries.',
        'category': 'Tours',
        'location': 'Göreme, Cappadocia',
        'price': 30,
        'imageUrl': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?auto=format&fit=crop&q=80&w=600',
      },
      {
        'id': 'exp_cooking_class',
        'title': 'Traditional Anatolian Cooking Class & Wine Tasting',
        'description': 'Learn to prepare traditional home-cooked Turkish meals in a cave kitchen, using fresh, locally sourced ingredients. Paired with fine local Cappadocia wines.',
        'category': 'Workshops',
        'location': 'Uçhisar, Cappadocia',
        'price': 85,
        'imageUrl': 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?auto=format&fit=crop&q=80&w=600',
      },
      {
        'id': 'exp_turkish_hamam',
        'title': 'Historic Turkish Bath (Hamam) Experience',
        'description': 'Pamper yourself with a luxurious foam massage and exfoliating scrub inside a beautiful, dome-ceilinged Ottoman-era bathhouse built in the 16th century.',
        'category': 'Boutique Hotels',
        'location': 'Sultanahmet, Istanbul',
        'price': 90,
        'imageUrl': 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&q=80&w=600',
      },
      {
        'id': 'exp_bosphorus_sunset',
        'title': 'Luxury Bosphorus Sunset Yacht Cruise',
        'description': 'Sail along the Bosphorus Strait dividing Europe and Asia. Enjoy stunning sunset views of Istanbul\'s historic mansions, palaces, and minarets with refreshments.',
        'category': 'Tours',
        'location': 'Beşiktaş, Istanbul',
        'price': 120,
        'imageUrl': 'https://images.unsplash.com/photo-1505262890022-02914d5f665a?auto=format&fit=crop&q=80&w=600',
      },
      {
        'id': 'exp_hiking_rose_valley',
        'title': 'Guided Hiking Tour of Rose & Red Valleys',
        'description': 'Hike through Cappadocia\'s most colorful valleys, discovering hidden rock-cut pigeon houses, vineyards, and ancient churches along the way. Includes a sunset viewpoint finish.',
        'category': 'Tours',
        'location': 'Cavusin, Cappadocia',
        'price': 45,
        'imageUrl': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&q=80&w=600',
      },
      {
        'id': 'exp_derinkuyu_underground',
        'title': 'Derinkuyu Deep Underground City Exploration',
        'description': 'Descend into Turkey\'s deepest excavated underground city, which once housed up to 20,000 people fleeing persecution. Explore ventilation shafts, stables, and chapels.',
        'category': 'Tours',
        'location': 'Derinkuyu, Cappadocia',
        'price': 40,
        'imageUrl': 'https://images.unsplash.com/photo-1447069387593-a5de0862481e?auto=format&fit=crop&q=80&w=600',
      },
      {
        'id': 'exp_fine_dining',
        'title': 'Rooftop Fine Dining at Mikla',
        'description': 'Savor a multi-course New Anatolian tasting menu featuring cutting-edge culinary techniques, served alongside breath-taking panoramic views of the illuminated Istanbul skyline.',
        'category': 'Fine Dining',
        'location': 'Beyoğlu, Istanbul',
        'price': 180,
        'imageUrl': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=600',
      },
    ];

    for (var exp in experiences) {
      final docRef = firestore.collection('inventory').doc(exp['id'] as String);
      batch.set(docRef, {
        'title': exp['title'],
        'description': exp['description'],
        'category': exp['category'],
        'location': exp['location'],
        'price': exp['price'],
        'imageUrl': exp['imageUrl'],
      });
    }

    await batch.commit();
  }
}

class _DiscoveryCard extends ConsumerWidget {
  final InventoryItem item;

  const _DiscoveryCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final itineraryState = ref.watch(itineraryProvider);
    final inItinerary = itineraryState.maybeWhen(
      data: (items) => items.any((i) => i.id == item.id),
      orElse: () => false,
    );

    return GestureDetector(
      onTap: () {
        // Navigate to details (TBD)
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: AspectRatio(
                aspectRatio: 1, // Bento feel
                child: item.imageUrl != null
                    ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                    : Container(color: AppColors.surfaceVariant),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          inItinerary ? LucideIcons.bookmarkCheck : LucideIcons.bookmark,
                          size: 18,
                          color: inItinerary ? AppColors.primary : AppColors.outline,
                        ),
                        onPressed: () {
                          if (inItinerary) {
                            ref.read(itineraryActionsProvider).removeFromItinerary(item.id);
                          } else {
                            ref.read(itineraryActionsProvider).addToItinerary(item);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.location,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
