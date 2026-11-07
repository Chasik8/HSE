import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:city_layout_task/main.dart';

void main() {
  testWidgets('starter launches', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CitiesPage()));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(CitiesPage), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
