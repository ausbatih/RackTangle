import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:racktangle/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ════════════════════════════════════════════
  // HOME SCREEN
  // ════════════════════════════════════════════

  testWidgets('Home screen loads and shows all three buttons',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Play'), findsOneWidget);
    expect(find.text('How to Play'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Tapping Play navigates to Level 1',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Crossings'), findsOneWidget);
    expect(
      find.text('Drag cable endpoints to untangle all connection'),
      findsOneWidget,
    );
  });

  testWidgets('Tapping How to Play navigates away from HomeScreen',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('How to Play'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsWidgets);
  });

  testWidgets('Tapping Settings shows sound toggle options',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Background Music'), findsOneWidget);
    expect(find.text('Sound Effects'), findsOneWidget);
  });

  // ════════════════════════════════════════════
  // SETTINGS SCREEN
  // ════════════════════════════════════════════

  testWidgets('Settings shows SOUNDS, PROGRESS, DATA sections',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('SOUNDS'), findsOneWidget);
    expect(find.text('PROGRESS'), findsOneWidget);
    expect(find.text('DATA'), findsOneWidget);
  });

  testWidgets('Settings has two Switch widgets for audio toggles',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.byType(Switch), findsNWidgets(2));
  });

  testWidgets('Settings shows Current Level and Modules Completed cards',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Current Level'), findsOneWidget);
    expect(find.text('Modules Completed'), findsOneWidget);
  });

  testWidgets('Settings back button returns to HomeScreen',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Play'), findsOneWidget);
  });

  // ════════════════════════════════════════════
  // LEVEL 1
  // ════════════════════════════════════════════

  testWidgets('Level 1 shows timer at 00:00 on load',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    expect(find.text('00:00'), findsOneWidget);
  });

  testWidgets('Level 1 shows a pause button', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.pause), findsOneWidget);
  });

  testWidgets('Level 1 pause button opens dialog with Resume and Restart options',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.pause));
    await tester.pumpAndSettle();

    expect(find.text('LEVEL 1'), findsOneWidget);
    expect(find.text('Paused'), findsOneWidget);
    expect(find.text('Resume'), findsOneWidget);
    expect(find.text('Restart Level'), findsOneWidget);
    expect(find.text('Back to home'), findsOneWidget);
  });

  testWidgets('Resume button closes the pause dialog',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.pause));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();

    expect(find.text('Paused'), findsNothing);
    expect(find.textContaining('Crossings'), findsOneWidget);
  });

  testWidgets('Back to home from pause dialog returns to HomeScreen',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.pause));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Back to home'));
    await tester.pumpAndSettle();

    expect(find.text('Play'), findsOneWidget);
    expect(find.text('How to Play'), findsOneWidget);
  });

  testWidgets('Restart Level resets the timer to 00:00',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    // Advance the timer by pumping frames
    await tester.pump(const Duration(seconds: 3));

    await tester.tap(find.byIcon(Icons.pause));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Restart Level'));
    await tester.pumpAndSettle();

    expect(find.text('00:00'), findsOneWidget);
  });
}