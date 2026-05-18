import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:racktangle/main.dart' as app;
import 'package:racktangle/Levels/Level2.dart';
import 'package:racktangle/Levels/Level3.dart';
import 'package:racktangle/Levels/Level4.dart';
import 'package:racktangle/Levels/Level5.dart';
import 'package:racktangle/Levels/Level6.dart';
import 'package:racktangle/Levels/Level7.dart';
import 'package:racktangle/Levels/Level8.dart';
import 'package:racktangle/Levels/Level9.dart';
import 'package:racktangle/Levels/Level10.dart';

// ---------------------------------------------------------------------------
// HELPER — use this instead of pumpAndSettle() after any navigation or screen
// that has a looping animation (BGM visualizer, level canvas, etc.).
// It pumps frames for a fixed duration so we never time out waiting for an
// animation that runs forever.
// ---------------------------------------------------------------------------
Future<void> _settle(PatrolIntegrationTester $, [int seconds = 5]) async {
  await $.tester.pump(Duration(seconds: seconds));
  await $.tester.pump(Duration(seconds: seconds));
}

void main() {
  // ═══════════════════════════════════════════════════
  // HOME SCREEN
  // ═══════════════════════════════════════════════════

  patrolTest(
    'Home screen shows Play, How to Play, and Settings buttons',
    ($) async {
      app.main();
      await _settle($, 6); // wait for splash/intro animation

      expect(find.text('Play'), findsOneWidget);
      expect(find.text('How to Play'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    },
  );

  patrolTest(
    'Play button navigates to Level 1',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Play'));
      await _settle($, 6); // level canvas may have continuous animation

      expect(find.textContaining('Crossings'), findsOneWidget);
      expect(
        find.text('Drag cable endpoints to untangle all connection'),
        findsOneWidget,
      );
    },
  );

  patrolTest(
    'How to Play button navigates to HowToPlay screen',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('How to Play'));
      await _settle($, 6); // HowToPlay may have looping animation

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsWidgets);
    },
  );

  patrolTest(
    'How to Play back button returns to Home',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('How to Play'));
      await _settle($, 6);

      await $.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await _settle($, 6);

      expect(find.text('Play'), findsOneWidget);
    },
  );

  patrolTest(
    'Settings button navigates to Settings screen',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Settings'));
      await _settle($, 6);

      expect(find.text('SOUNDS'), findsOneWidget);
      expect(find.text('Background Music'), findsOneWidget);
      expect(find.text('Sound Effects'), findsOneWidget);
    },
  );

  // ═══════════════════════════════════════════════════
  // SETTINGS SCREEN
  // ═══════════════════════════════════════════════════

  patrolTest(
    'Settings screen shows all three sections',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Settings'));
      await _settle($, 6);

      expect(find.text('SOUNDS'), findsOneWidget);
      expect(find.text('PROGRESS'), findsOneWidget);
      expect(find.text('DATA'), findsOneWidget);
    },
  );

  patrolTest(
    'Settings Background Music toggle changes state',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Settings'));
      await _settle($, 6);

      final toggle = find.byType(Switch).at(0);
      final before = $.tester.widget<Switch>(toggle).value;

      await $.tester.tap(toggle);
      await $.tester.pump(const Duration(milliseconds: 500));

      expect($.tester.widget<Switch>(toggle).value, isNot(before));
    },
  );

  patrolTest(
    'Settings Sound Effects toggle changes state',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Settings'));
      await _settle($, 6);

      final toggle = find.byType(Switch).at(1);
      final before = $.tester.widget<Switch>(toggle).value;

      await $.tester.tap(toggle);
      await $.tester.pump(const Duration(milliseconds: 500));

      expect($.tester.widget<Switch>(toggle).value, isNot(before));
    },
  );

  patrolTest(
    'Settings shows Current Level and Modules Completed cards',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Settings'));
      await _settle($, 6);

      expect(find.text('Current Level'), findsOneWidget);
      expect(find.text('Modules Completed'), findsOneWidget);
    },
  );

  patrolTest(
    'Reset Progress resets level display to Level 1',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Settings'));
      await _settle($, 6);

      await $.tester
          .drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await $.tester.pump(const Duration(milliseconds: 500));

      await $.tap(find.text('Reset Progress'));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.textContaining('Level 1 of'), findsOneWidget);
    },
  );

  patrolTest(
    'Settings back button returns to Home screen',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Settings'));
      await _settle($, 6);

      await $.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await _settle($, 6);

      expect(find.text('Play'), findsOneWidget);
    },
  );

  // ═══════════════════════════════════════════════════
  // LEVEL 1 — no learning card, timer starts immediately
  // ═══════════════════════════════════════════════════

  patrolTest(
    'Level 1 shows timer at 00:00, crossings counter, and pause button',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Play'));
      await _settle($, 6);

      expect(find.text('00:00'), findsOneWidget);
      expect(find.textContaining('Crossings'), findsOneWidget);
      expect(find.byIcon(Icons.pause), findsOneWidget);
    },
  );

  patrolTest(
    'Level 1 timer increments after a few seconds',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Play'));
      await _settle($, 6);

      // Let real time pass then pump frames so the timer widget rebuilds
      await Future<void>.delayed(const Duration(seconds: 3));
      await $.tester.pump(const Duration(seconds: 1));

      expect(find.text('00:00'), findsNothing);
    },
  );

  patrolTest(
    'Level 1 pause dialog shows correct content',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Play'));
      await _settle($, 6);

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('LEVEL 1'), findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
      expect(find.text('Time'), findsOneWidget);
      expect(find.text('Crossings Left'), findsOneWidget);
      expect(find.text('Resume'), findsOneWidget);
      expect(find.text('Restart Level'), findsOneWidget);
      expect(find.text('Back to home'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 1 pause dialog - Resume closes dialog',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Play'));
      await _settle($, 6);

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      await $.tap(find.text('Resume'));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Paused'), findsNothing);
      expect(find.textContaining('Crossings'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 1 pause dialog - Restart Level resets timer to 00:00',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Play'));
      await _settle($, 6);

      await Future<void>.delayed(const Duration(seconds: 2));
      await $.tester.pump(const Duration(seconds: 1));

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      await $.tap(find.text('Restart Level'));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('00:00'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 1 pause dialog - Back to home returns to HomeScreen',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Play'));
      await _settle($, 6);

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      await $.tap(find.text('Back to home'));
      await _settle($, 6);

      expect(find.text('Play'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 1 pause dialog cannot be dismissed by tapping outside',
    ($) async {
      app.main();
      await _settle($, 6);

      await $.tap(find.text('Play'));
      await _settle($, 6);

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      await $.tester.tapAt(const Offset(10, 10));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Paused'), findsOneWidget);
    },
  );

  // ═══════════════════════════════════════════════════
  // LEVEL 2 — has learning card
  // ═══════════════════════════════════════════════════

  patrolTest(
    'Level 2 shows learning module before gameplay',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level2Screen()),
      );
      await _settle($, 6);

      expect(find.text('LEARNING MODULE'), findsOneWidget);
      expect(find.textContaining('Ready to Play'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 2 timer stays frozen while learning module is shown',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level2Screen()),
      );
      await _settle($, 6);

      await Future<void>.delayed(const Duration(seconds: 2));
      await $.tester.pump(const Duration(seconds: 1));

      expect(find.text('00:00'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 2 Ready to Play dismisses module and starts game',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level2Screen()),
      );
      await _settle($, 6);

      await $.tap(find.textContaining('Ready to Play'));
      await _settle($, 6);

      expect(find.text('LEARNING MODULE'), findsNothing);
      expect(find.textContaining('Crossings'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 2 timer increments after Ready to Play',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level2Screen()),
      );
      await _settle($, 6);

      await $.tap(find.textContaining('Ready to Play'));
      await _settle($, 6);

      await Future<void>.delayed(const Duration(seconds: 3));
      await $.tester.pump(const Duration(seconds: 1));

      expect(find.text('00:00'), findsNothing);
    },
  );

  patrolTest(
    'Level 2 pause dialog shows LEVEL 2',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level2Screen()),
      );
      await _settle($, 6);

      await $.tap(find.textContaining('Ready to Play'));
      await _settle($, 6);

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('LEVEL 2'), findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
    },
  );

  // ═══════════════════════════════════════════════════
  // LEVEL 3 — no learning card
  // ═══════════════════════════════════════════════════

  patrolTest(
    'Level 3 shows HUD and pause button immediately',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level3Screen()),
      );
      await _settle($, 6);

      expect(find.textContaining('Crossings'), findsOneWidget);
      expect(find.byIcon(Icons.pause), findsOneWidget);
    },
  );

  patrolTest(
    'Level 3 pause dialog shows LEVEL 3',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level3Screen()),
      );
      await _settle($, 6);

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('LEVEL 3'), findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
    },
  );

  // ═══════════════════════════════════════════════════
  // LEVEL 4 — has learning card (Hub)
  // ═══════════════════════════════════════════════════

  patrolTest(
    'Level 4 shows Hub learning module',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level4Screen()),
      );
      await _settle($, 6);

      expect(find.text('LEARNING MODULE'), findsOneWidget);
      expect(find.text('NETWORK HUB'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 4 pause dialog shows LEVEL 4 after dismissing module',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level4Screen()),
      );
      await _settle($, 6);

      await $.tap(find.textContaining('Ready to Play'));
      await _settle($, 6);

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('LEVEL 4'), findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
    },
  );

  // ═══════════════════════════════════════════════════
  // LEVELS 5–7
  // ═══════════════════════════════════════════════════

  patrolTest(
    'Level 5 pause dialog shows LEVEL 5',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level5Screen()),
      );
      await _settle($, 6);

      if (find.textContaining('Ready to Play').evaluate().isNotEmpty) {
        await $.tap(find.textContaining('Ready to Play'));
        await _settle($, 6);
      }

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('LEVEL 5'), findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 6 pause dialog shows LEVEL 6',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level6Screen()),
      );
      await _settle($, 6);

      if (find.textContaining('Ready to Play').evaluate().isNotEmpty) {
        await $.tap(find.textContaining('Ready to Play'));
        await _settle($, 6);
      }

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('LEVEL 6'), findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 7 pause dialog shows LEVEL 7',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level7Screen()),
      );
      await _settle($, 6);

      if (find.textContaining('Ready to Play').evaluate().isNotEmpty) {
        await $.tap(find.textContaining('Ready to Play'));
        await _settle($, 6);
      }

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('LEVEL 7'), findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
    },
  );

  // ═══════════════════════════════════════════════════
  // LEVEL 8 — has learning card (Reliability & Redundancy)
  // ═══════════════════════════════════════════════════

  patrolTest(
    'Level 8 shows Reliability and Redundancy learning module',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level8Screen()),
      );
      await _settle($, 6);

      expect(find.text('LEARNING MODULE'), findsOneWidget);
      expect(find.text('Reliability & Redundancy'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 8 pause dialog shows LEVEL 8 after dismissing module',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level8Screen()),
      );
      await _settle($, 6);

      await $.tap(find.textContaining('Ready to Play'));
      await _settle($, 6);

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('LEVEL 8'), findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
    },
  );

  // ═══════════════════════════════════════════════════
  // LEVEL 9 — has learning card (ISP Redundancy)
  // ═══════════════════════════════════════════════════

  patrolTest(
    'Level 9 shows ISP Redundancy learning module',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level9Screen()),
      );
      await _settle($, 6);

      expect(find.text('LEARNING MODULE'), findsOneWidget);
      expect(find.text('ISP Redundancy'), findsOneWidget);
    },
  );

  patrolTest(
    'Level 9 pause dialog shows LEVEL 9 after dismissing module',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level9Screen()),
      );
      await _settle($, 6);

      await $.tap(find.textContaining('Ready to Play'));
      await _settle($, 6);

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('LEVEL 9'), findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
    },
  );

  // ═══════════════════════════════════════════════════
  // LEVEL 10
  // ═══════════════════════════════════════════════════

  patrolTest(
    'Level 10 loads and shows pause button',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level10Screen()),
      );
      await _settle($, 6);

      if (find.textContaining('Ready to Play').evaluate().isNotEmpty) {
        await $.tap(find.textContaining('Ready to Play'));
        await _settle($, 6);
      }

      expect(find.byIcon(Icons.pause), findsOneWidget);
    },
  );

  patrolTest(
    'Level 10 pause dialog shows LEVEL 10',
    ($) async {
      await $.pumpWidgetAndSettle(
        const MaterialApp(home: Level10Screen()),
      );
      await _settle($, 6);

      if (find.textContaining('Ready to Play').evaluate().isNotEmpty) {
        await $.tap(find.textContaining('Ready to Play'));
        await _settle($, 6);
      }

      await $.tap(find.byIcon(Icons.pause));
      await $.tester.pump(const Duration(milliseconds: 500));

      expect(find.text('LEVEL 10'), findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
    },
  );
}
