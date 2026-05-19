import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:travelanatolia/ui/theme.dart';
import 'package:travelanatolia/ui/widgets/glass_panel.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: GlassPanel(
        borderRadius: 30,
        blur: 20,
        opacity: 0.9,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: LucideIcons.compass,
              label: 'Explore',
              isActive: location.startsWith('/explore'),
              route: '/explore',
            ),
            _buildNavItem(
              context: context,
              icon: LucideIcons.sparkles,
              label: 'ANA',
              isActive: location == '/',
              route: '/',
            ),
            _buildNavItem(
              context: context,
              icon: LucideIcons.map,
              label: 'Itinerary',
              isActive: location.startsWith('/itinerary'),
              route: '/itinerary',
            ),
            _buildNavItem(
              context: context,
              icon: LucideIcons.user,
              label: 'Profile',
              isActive: location.startsWith('/profile'),
              route: '/profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required String route,
  }) {
    final color = isActive ? AppColors.primary : AppColors.secondary.withValues(alpha: 0.4);
    
    return GestureDetector(
      onTap: () => context.go(route),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
