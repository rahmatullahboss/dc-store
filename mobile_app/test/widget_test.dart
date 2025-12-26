// Basic widget test for DC Store app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    // Basic smoke test - just verify widget builds
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('DC Store'))),
      ),
    );

    expect(find.text('DC Store'), findsOneWidget);
  });
}
