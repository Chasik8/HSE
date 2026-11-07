// flutter test test/behavior_check.dart — после реализации TODO.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:city_layout_task/main.dart';
import 'font_setup.dart';

void main() {
  setUpAll(loadTestFonts);

  testWidgets('ready method completes after 500 ms', (tester) async {
    var completed = false;
    final pending = loadCities().then((data) {
      completed = true;
      return data;
    });
    await tester.pump(const Duration(milliseconds: 499));
    expect(completed, false);
    await tester.pump(const Duration(milliseconds: 1));
    final data = await pending;
    expect(data.length, 6);
    expect(completed, true);
  });

  testWidgets('first load shows progress for 500 ms', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CitiesPage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 499));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Москва'), findsOneWidget);
  });

  testWidgets('layout changes do not start another load', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CitiesPage()));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.tap(find.text('Сетка'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(GridView), findsOneWidget);
    await tester.tap(find.text('Список'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('refresh shows waiting and preserves current mode', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CitiesPage()));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.text('Обновить'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Москва'), findsNothing);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Сетка'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 299));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(GridView), findsOneWidget);
  });

  for (final width in [320.0, 800.0]) {
    for (final grid in [false, true]) {
      testWidgets(
        'last city is readable at $width in ${grid ? "grid" : "list"}',
        (tester) async {
          tester.view.physicalSize = Size(width, 480);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await tester.pumpWidget(const MaterialApp(home: CitiesPage()));
          await tester.pump(const Duration(milliseconds: 500));
          if (grid) {
            await tester.tap(find.text('Сетка'));
            await tester.pump();
          }
          final container = find.byType(grid ? GridView : ListView);
          expect(container, findsOneWidget);
          final last = find.text('Петропавловск-Камчатский');
          await tester.scrollUntilVisible(
            last,
            160,
            scrollable: find.descendant(
              of: container,
              matching: find.byType(Scrollable),
            ),
          );
          await Scrollable.ensureVisible(tester.element(last), alignment: 1);
          await tester.pumpAndSettle();
          expect(last.hitTestable(), findsOneWidget);
          expect(find.text('7 °C'), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
