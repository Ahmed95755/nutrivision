import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivision/app.dart';

void main() {
  testWidgets('NutriVision app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NutriVisionApp());

    expect(find.text('Welcome to NutriVision'), findsOneWidget);
  });
}
