import 'package:flutter/material.dart';

import 'package:bhumilestari_mobile/chat.dart';
import 'package:bhumilestari_mobile/menu.dart';
import 'package:bhumilestari_mobile/navigation/app_route_names.dart';
import 'package:bhumilestari_mobile/navigation/feature_placeholder_page.dart';
import 'package:bhumilestari_mobile/produk.dart';
import 'package:bhumilestari_mobile/user/screens/login.dart';
import 'package:bhumilestari_mobile/user/screens/register.dart';

abstract final class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    AppRouteNames.home: (_) => const OurHomePage(),
    AppRouteNames.products: (_) => const ProdukPage(),
    AppRouteNames.legacyProducts: (_) => const ProdukPage(),
    AppRouteNames.cart: (_) => const FeaturePlaceholderPage(
      title: 'Keranjang',
      description: 'Halaman keranjang akan dihubungkan ke Checkout API.',
      icon: Icons.shopping_cart_outlined,
    ),
    AppRouteNames.orders: (_) => const FeaturePlaceholderPage(
      title: 'Pesanan',
      description: 'Riwayat dan status pesanan akan ditampilkan di sini.',
      icon: Icons.receipt_long_outlined,
    ),
    AppRouteNames.salesReport: (_) => const FeaturePlaceholderPage(
      title: 'Laporan Penjualan',
      description: 'Analitik penjualan seller akan ditampilkan di sini.',
      icon: Icons.bar_chart_outlined,
    ),
    AppRouteNames.chat: (_) => const BuyerChatListPage(),
    AppRouteNames.profile: (_) => const FeaturePlaceholderPage(
      title: 'Profil Pengguna',
      description: 'Profil dan pengaturan akun akan ditampilkan di sini.',
      icon: Icons.person_outline,
    ),
    AppRouteNames.login: (_) => const LoginPage(),
    AppRouteNames.register: (_) => const RegisterPage(),
    AppRouteNames.productVerification: (_) => const FeaturePlaceholderPage(
      title: 'Verifikasi Produk',
      description: 'Antrean verifikasi produk untuk admin.',
      icon: Icons.verified_outlined,
    ),
    AppRouteNames.reviewModeration: (_) => const FeaturePlaceholderPage(
      title: 'Moderasi Ulasan',
      description: 'Laporan ulasan untuk ditinjau oleh admin.',
      icon: Icons.rate_review_outlined,
    ),
  };
}
