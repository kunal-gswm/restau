import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khana_app/main.dart';
import 'package:khana_app/features/auth/presentation/pages/login_screen.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: KhanaApp()));
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
