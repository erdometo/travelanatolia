import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelanatolia/ui/theme.dart';
import 'package:travelanatolia/ui/widgets/glass_panel.dart';
import 'package:travelanatolia/features/explore/explore_provider.dart';
import 'package:travelanatolia/features/explore/models/inventory_item.dart';
import 'package:travelanatolia/features/itinerary/itinerary_provider.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreState = ref.watch(exploreProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: GlassPanel(
          borderRadius: 0,
          blur: 10,
          opacity: 0.8,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    'TravelAnatolia',
                    style: GoogleFonts.notoSerif(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=traveler'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 120, left: 20, right: 20, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discover Beyond',
              style: GoogleFonts.notoSerif(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            _buildCategories(ref),
            const SizedBox(height: 32),
            exploreState.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text("No experiences found."));
                }
                return _buildBentoGrid(items);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categories = ['All', 'Fine Dining', 'Run Clubs', 'Boutique Hotels', 'Workshops', 'Tours'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = cat == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  print('Selected category: $cat');
                  ref.read(selectedCategoryProvider.notifier).state = cat;
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBentoGrid(List<InventoryItem> items) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: _ExperienceCard(item: item),
        );
      }).toList(),
    );
  }
}

class _ExperienceCard extends ConsumerWidget {
  final InventoryItem item;

  const _ExperienceCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itineraryState = ref.watch(itineraryProvider);
    final inItinerary = itineraryState.maybeWhen(
      data: (items) => items.any((i) => i.id == item.id),
      orElse: () => false,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: AppColors.surfaceVariant.withOpacity(0.3),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: AppColors.primary.withOpacity(0.1),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 64,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: GlassPanel(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  borderRadius: 20,
                  child: Row(
                    children: [
                      const Icon(Icons.category, size: 16, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        item.category.toUpperCase(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.notoSerif(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        inItinerary ? Icons.bookmark : Icons.bookmark_border,
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(
                      item.location,
                      style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      '\$${item.price}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.description,
                  style: TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
