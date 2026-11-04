import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing/main.dart';

void main() {
  testWidgets('Caesar: HELLO jadi KHOOR', (WidgetTester tester) async {
    await tester.pumpWidget(const SandiApp());

    await tester.enterText(find.byType(TextField), 'HELLO');
    await tester.pump();

    expect(find.text('KHOOR'), findsOneWidget);
  });
}