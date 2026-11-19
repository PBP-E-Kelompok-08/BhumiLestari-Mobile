// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:bhumilestari_mobile/main.dart';
import 'package:bhumilestari_mobile/navigation/app_navigation_config.dart';
import 'package:bhumilestari_mobile/navigation/app_route_names.dart';
import 'package:bhumilestari_mobile/navigation/app_router.dart';
import 'package:bhumilestari_mobile/navigation/app_user_role.dart';

void main() {
  testWidgets('menampilkan halaman utama BhumiLestari', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('BhumiLestari'), findsOneWidget);
    expect(
      find.text(
        'Salam hangat dari Tim BhumiLestari - Sedang dalam pengembangan',
      ),
      findsOneWidget,
    );
  });

  testWidgets('navigasi home membuka halaman produk', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Produk'));
    await tester.pumpAndSettle();

    expect(find.text('Halaman Produk - Sedang pengembangan'), findsOneWidget);
  });

  testWidgets('navigasi home membuka placeholder pesanan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Pesanan'));
    await tester.pumpAndSettle();

    expect(
      find.text('Riwayat dan status pesanan akan ditampilkan di sini.'),
      findsOneWidget,
    );
  });

  test('router mendaftarkan route utama aplikasi', () {
    expect(
      AppRouter.routes.keys,
      containsAll([
        AppRouteNames.home,
        AppRouteNames.products,
        AppRouteNames.cart,
        AppRouteNames.orders,
        AppRouteNames.salesReport,
        AppRouteNames.chat,
        AppRouteNames.profile,
      ]),
    );
  });

  test('navigasi buyer memuat fitur yang sesuai role', () {
    final routes = AppNavigationConfig.destinationsFor(AppUserRole.buyer)
        .map((destination) => destination.route);

    expect(routes, [
      AppRouteNames.products,
      AppRouteNames.cart,
      AppRouteNames.orders,
      AppRouteNames.chat,
      AppRouteNames.profile,
    ]);
  });

  test('navigasi admin tidak memuat keranjang dan chat', () {
    final routes = AppNavigationConfig.destinationsFor(AppUserRole.admin)
        .map((destination) => destination.route);

    expect(routes, contains(AppRouteNames.productVerification));
    expect(routes, contains(AppRouteNames.reviewModeration));
    expect(routes, isNot(contains(AppRouteNames.cart)));
    expect(routes, isNot(contains(AppRouteNames.chat)));
  });
}
