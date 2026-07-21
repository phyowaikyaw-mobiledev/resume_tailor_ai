import 'package:flutter_test/flutter_test.dart';
import 'package:resumetailorai/main.dart';

void main() {
  testWidgets('shows setup screen when env is missing', (WidgetTester tester) async {
    await tester.pumpWidget(const ResumeTailorApp(
      envError: 'GROQ_API_KEY is missing from your .env file.',
    ));

    // SplashScreen routes to the setup screen after ~1.5s.
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.text('Setup Required'), findsOneWidget);
    expect(find.textContaining('GROQ_API_KEY'), findsWidgets);
  });
}
