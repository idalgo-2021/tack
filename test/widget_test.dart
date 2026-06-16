import 'package:flutter_test/flutter_test.dart';
import 'package:tack/app.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const TackApp());
    expect(find.byType(TackApp), findsOneWidget);
  });
}
