import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:travelanatolia/ui/theme.dart';
import 'package:travelanatolia/ui/widgets/glass_panel.dart';
import 'package:travelanatolia/features/itinerary/itinerary_provider.dart';

class ItineraryScreen extends ConsumerWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final itineraryState = ref.watch(itineraryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Architected Itinerary', style: theme.textTheme.headlineSmall),
      ),
      body: itineraryState.when(
        data: (items) {
          if (items.isEmpty) {
            return _buildEmptyState(theme);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return FadeInLeft(
                delay: Duration(milliseconds: 100 * index),
                child: _TimelineItem(
                  item: item,
                  isFirst: index == 0,
                  isLast: index == items.length - 1,
                  onDelete: () => ref.read(itineraryActionsProvider).removeFromItinerary(item.id),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.calendarOff, size: 64, color: AppColors.outlineVariant),
          const SizedBox(height: 24),
          Text(
            'Your story hasn\'t started yet.',
            style: theme.textTheme.titleMedium?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            'Save experiences to build your timeline.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final dynamic item;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onDelete;

  const _TimelineItem({
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline Line & Dot
          Column(
            children: [
              Container(
                width: 2,
                height: 20,
                color: isFirst ? Colors.transparent : AppColors.outlineVariant,
              ),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast ? Colors.transparent : AppColors.outlineVariant,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: GlassPanel(
                padding: const EdgeInsets.all(20),
                borderRadius: 24,
                child: Row(
                  children: [
                    if (item.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item.imageUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(LucideIcons.image),
                      ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(LucideIcons.mapPin, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(item.location, style: theme.textTheme.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('\$${item.price}', style: theme.textTheme.labelLarge),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.trash2, size: 20, color: AppColors.error),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
