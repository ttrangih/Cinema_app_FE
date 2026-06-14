import 'package:flutter_test/flutter_test.dart';
import 'package:cinema_app/main.dart';

void main() {
  testWidgets('Cinema app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CinemaApp());

    expect(find.text('Cinema App'), findsOneWidget);
  });
}