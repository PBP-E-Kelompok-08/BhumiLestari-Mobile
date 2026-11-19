// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:bhumilestari_mobile/main.dart';

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
}
