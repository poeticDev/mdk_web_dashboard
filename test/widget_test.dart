// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:web_dashboard/main.dart';

void main() {
  testWidgets('Login page renders header text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );

    await tester.pumpAndSettle();

    expect(find.text('MDK 관제 대시보드'), findsOneWidget);
    expect(find.text('사내 계정으로 인증한 후 관제 대시보드에 접근하세요.'), findsOneWidget);
  });
}
