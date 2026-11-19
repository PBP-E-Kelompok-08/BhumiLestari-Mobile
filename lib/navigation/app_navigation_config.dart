import 'package:flutter/material.dart';

import 'package:bhumilestari_mobile/navigation/app_route_names.dart';
import 'package:bhumilestari_mobile/navigation/app_user_role.dart';

class AppNavigationDestination {
  const AppNavigationDestination({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

abstract final class AppNavigationConfig {
  static const _home = AppNavigationDestination(
    label: 'Ringkasan',
    icon: Icons.space_dashboard_outlined,
    route: AppRouteNames.home,
  );
  static const _products = AppNavigationDestination(
    label: 'Produk',
    icon: Icons.inventory_2_outlined,
    route: AppRouteNames.products,
  );
  static const _cart = AppNavigationDestination(
    label: 'Keranjang',
    icon: Icons.shopping_cart_outlined,
    route: AppRouteNames.cart,
  );
  static const _orders = AppNavigationDestination(
    label: 'Pesanan',
    icon: Icons.receipt_long_outlined,
    route: AppRouteNames.orders,
  );
  static const _purchaseHistory = AppNavigationDestination(
    label: 'Riwayat Beli',
    icon: Icons.receipt_long_outlined,
    route: AppRouteNames.orders,
  );
  static const _salesReport = AppNavigationDestination(
    label: 'Lap. Penjualan',
    icon: Icons.bar_chart_outlined,
    route: AppRouteNames.salesReport,
  );
  static const _chat = AppNavigationDestination(
    label: 'Chat',
    icon: Icons.chat_outlined,
    route: AppRouteNames.chat,
  );
  static const _profile = AppNavigationDestination(
    label: 'Pengguna',
    icon: Icons.person_outline,
    route: AppRouteNames.profile,
  );
  static const _login = AppNavigationDestination(
    label: 'Login',
    icon: Icons.login,
    route: AppRouteNames.login,
  );
  static const _verification = AppNavigationDestination(
    label: 'Verifikasi',
    icon: Icons.verified_outlined,
    route: AppRouteNames.productVerification,
  );
  static const _moderation = AppNavigationDestination(
    label: 'Moderasi',
    icon: Icons.rate_review_outlined,
    route: AppRouteNames.reviewModeration,
  );

  static List<AppNavigationDestination> destinationsFor(AppUserRole role) =>
      switch (role) {
        AppUserRole.guest => const [_products, _login],
        AppUserRole.buyer => const [
          _products,
          _cart,
          _purchaseHistory,
          _chat,
          _profile,
        ],
        AppUserRole.seller => const [
          _home,
          _products,
          _orders,
          _salesReport,
          _chat,
          _profile,
        ],
        AppUserRole.admin => const [
          _verification,
          _moderation,
          _salesReport,
          _profile,
        ],
      };
}
