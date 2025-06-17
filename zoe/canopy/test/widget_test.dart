// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:canopy/main.dart';

void main() {
  testWidgets('CoherencyApp shows correct text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CoherencyApp());

    // Verify that the expected text is shown.
    expect(find.text('Frontend Foundation: Secure and Operational.'),
        findsOneWidget);
    expect(find.text('Coherency'), findsOneWidget);
  });
}
