import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
                      await FirebaseFunctions.instanceFor(region: 'europe-west3')
                          .httpsCallable('seedDatabase')
                          .call();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('World populated.')),
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
