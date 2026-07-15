import 'package:flutter_test/flutter_test.dart';
import 'package:khana_app/main.dart';
import 'package:khana_app/features/home/presentation/pages/home_screen.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KhanaApp());
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
