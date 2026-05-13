import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    
    return GlassPanel(
      borderRadius: 0,
      blur: 20,
      opacity: 0.8,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24, top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.explore,
              label: 'Explore',
              isActive: location.startsWith('/explore'),
              route: '/explore',
            ),
            _buildNavItem(
              context: context,
              icon: Icons.auto_awesome,
              label: 'ANA',
              isActive: location == '/',
              route: '/',
            ),
            _buildNavItem(
              context: context,
              icon: Icons.map,
              label: 'Itinerary',
              isActive: location.startsWith('/itinerary'),
              route: '/itinerary',
            ),
            _buildNavItem(
              context: context,
              icon: Icons.person,
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
    final color = isActive ? AppColors.primary : AppColors.onSurfaceVariant.withOpacity(0.6);
    return GestureDetector(
      onTap: () {
        context.go(route);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
