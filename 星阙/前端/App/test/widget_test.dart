import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('basic widget tree can render', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('horosa-smoke'),
        ),
      ),
    );

    expect(find.text('horosa-smoke'), findsOneWidget);
  });
}
