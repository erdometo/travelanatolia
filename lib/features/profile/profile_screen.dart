import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:travelanatolia/features/auth/auth_provider.dart';
import 'package:travelanatolia/ui/theme.dart';
import 'package:travelanatolia/ui/widgets/glass_panel.dart';
import 'package:travelanatolia/ui/widgets/custom_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  IconData _getArchetypeIcon(String? travelStyle) {
    switch (travelStyle?.toLowerCase()) {
      case 'adventure':
        return LucideIcons.mountain;
      case 'history':
        return LucideIcons.scrollText;
      case 'culinary':
        return LucideIcons.chefHat;
      case 'relaxation':
        return LucideIcons.coffee;
      default:
        return LucideIcons.compass;
    }
  }

  String _getArchetypeTitle(String? travelStyle) {
    switch (travelStyle?.toLowerCase()) {
      case 'adventure':
        return 'The Pathfinder';
      case 'history':
        return 'The Chronicler';
      case 'culinary':
        return 'The Epicurean';
      case 'relaxation':
        return 'The Wanderer';
      default:
        return 'The Anatolian Traveler';
    }
  }

  Widget _buildNoProfileState(ThemeData theme) {
    return GlassPanel(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        children: [
          const Icon(LucideIcons.compass, size: 48, color: AppColors.outline),
          const SizedBox(height: 16),
          Text(
            'Travel Profile Not Initialized',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Complete the concierge onboarding quiz to analyze your traveler archetype.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.secondary,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1493246507139-91e8bef99c02?auto=format&fit=crop&q=80&w=1200',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(color: AppColors.secondary.withValues(alpha: 0.6)),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=traveler'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Traveler Identity',
                          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIdentitySection(theme, profileAsync),
                  const SizedBox(height: 32),
                  _buildSettingsSection(theme, ref),
                  const SizedBox(height: 48),
                  StitchButton(
                    label: 'SIGN OUT',
                    onPressed: () => ref.read(authProvider.notifier).signOut(),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentitySection(ThemeData theme, AsyncValue<Map<String, dynamic>?> profileAsync) {
    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return _buildNoProfileState(theme);
        }
        final travelStyle = profile['travelStyle'] as String?;
        final interests = List<String>.from(profile['interests'] ?? []);
        final personaDescription = profile['personaDescription'] as String? ?? '';
        final companion = profile['companion'] as String? ?? 'Solo';
        final budget = profile['budgetRange'] as String? ?? 'Moderate';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('YOUR ARCHETYPE', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2, color: AppColors.primary)),
            const SizedBox(height: 16),
            FadeInUp(
              child: GlassPanel(
                padding: const EdgeInsets.all(24),
                borderRadius: 24,
                child: Row(
                  children: [
                    Icon(_getArchetypeIcon(travelStyle), size: 32, color: AppColors.primary),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getArchetypeTitle(travelStyle), style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(personaDescription, style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('YOUR TRAVEL STYLE', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2, color: AppColors.primary)),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatCard(label: 'Budget', value: budget, icon: LucideIcons.wallet),
                const SizedBox(width: 16),
                _StatCard(label: 'Companion', value: companion, icon: LucideIcons.users),
              ],
            ),
            const SizedBox(height: 24),
            Text('INTEREST TAGS', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2, color: AppColors.primary)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: interests.map((interest) {
                return Chip(
                  label: Text(interest),
                  backgroundColor: AppColors.surfaceVariant.withValues(alpha: 0.5),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                );
              }).toList(),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (err, st) => Center(child: Text('Error loading profile: $err')),
    );
  }

  Widget _buildSettingsSection(ThemeData theme, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PREFERENCES', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 2, color: AppColors.primary)),
        const SizedBox(height: 16),
        _SettingsTile(icon: LucideIcons.bell, label: 'Notifications', onTap: () {}),
        _SettingsTile(icon: LucideIcons.shieldCheck, label: 'Privacy & Security', onTap: () {}),
        _SettingsTile(icon: LucideIcons.info, label: 'Concierge Support', onTap: () {}),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(value, style: theme.textTheme.headlineMedium),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.secondary, size: 20),
      title: Text(label, style: theme.textTheme.bodyLarge),
      trailing: const Icon(LucideIcons.chevronRight, size: 16),
    );
  }
}
