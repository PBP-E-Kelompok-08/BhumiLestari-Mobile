import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bhumilestari_mobile/navigation/app_navigation_config.dart';
import 'package:bhumilestari_mobile/navigation/app_route_names.dart';
import 'package:bhumilestari_mobile/navigation/app_user_role.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.role,
    required this.currentRoute,
    this.profileLabel,
    this.onReselect,
  });

  final AppUserRole role;
  final String currentRoute;
  final String? profileLabel;
  final VoidCallback? onReselect;

  @override
  Widget build(BuildContext context) {
    final destinations = AppNavigationConfig.destinationsFor(role);
    final selectedIndex = destinations.indexWhere(
      (destination) => destination.route == currentRoute,
    );

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF4A6358),
      selectedItemColor: const Color(0xFFF3EFC3),
      unselectedItemColor: const Color(0xFFF3EFC3),
      iconSize: 28,
      selectedLabelStyle: GoogleFonts.prompt(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.prompt(fontSize: 10),
      currentIndex: selectedIndex < 0 ? 0 : selectedIndex,
      onTap: (index) => _openDestination(context, destinations[index].route),
      items: destinations.map((destination) {
        final label =
            destination.route == AppRouteNames.profile &&
                profileLabel?.trim().isNotEmpty == true
            ? profileLabel!.trim()
            : destination.label;
        return BottomNavigationBarItem(
          icon: Icon(destination.icon),
          label: label,
        );
      }).toList(),
    );
  }

  void _openDestination(BuildContext context, String route) {
    if (route == currentRoute) {
      onReselect?.call();
      return;
    }

    final navigator = Navigator.of(context);
    if (route == AppRouteNames.home) {
      navigator.popUntil((current) => current.isFirst);
      return;
    }
    navigator.pushNamedAndRemoveUntil(route, (current) => current.isFirst);
  }
}
