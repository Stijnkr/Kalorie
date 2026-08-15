import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalorie/app/theme.dart';

void main() {
  testWidgets('light theme renders', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: kalorieTheme(brightness: Brightness.light),
        home: const Scaffold(body: Text('Kalorie')),
      ),
    );
    expect(find.text('Kalorie'), findsOneWidget);
  });
}
