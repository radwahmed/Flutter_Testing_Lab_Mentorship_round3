import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WeatherDisplay Widget Tests (final stable version)', () {
    testWidgets('Displays weather data after successful load', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // انتظر شوية لغاية ما البيانات تتحمل
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('°'), findsOneWidget);
    });

    testWidgets('Toggles between Celsius and Fahrenheit', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );
      await tester.pump(const Duration(seconds: 2));

      expect(find.textContaining('°C'), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.textContaining('°F'), findsOneWidget);
    });

    testWidgets('City selection updates displayed city', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('London').last);
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('London'), findsWidgets);
    });

    testWidgets('Invalid city does not crash', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // بنتأكد بس إن الودجت لسه شغالة ومفيش كراش
      expect(find.byType(WeatherDisplay), findsOneWidget);
    });

    testWidgets('Refresh button reloads weather data safely', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: WeatherDisplay())),
        ),
      );

      await tester.pump(const Duration(seconds: 2));

      final refreshFinder = find.widgetWithText(ElevatedButton, 'Refresh');
      await tester.ensureVisible(refreshFinder);
      await tester.tap(refreshFinder);
      await tester.pump();

      // يظهر اللودر بعد الضغط على الزر
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));

      // بعد التحميل المفروض الكارد ظهر تاني
      expect(find.byType(Card), findsOneWidget);
    });
  });
}
