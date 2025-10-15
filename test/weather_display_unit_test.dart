import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('Temperature Conversion', () {
    double celsiusToFahrenheit(num celsius) {
      return (celsius * 9 / 5) + 32;
    }

    double fahrenheitToCelsius(num fahrenheit) {
      return (fahrenheit - 32) * 5 / 9;
    }

    test('Celsius to Fahrenheit conversion is correct', () {
      expect(celsiusToFahrenheit(0), 32);
      expect(celsiusToFahrenheit(25), 77);
      expect(celsiusToFahrenheit(-10), 14);
      expect(celsiusToFahrenheit(100), 212); // حالة الغليان
      expect(celsiusToFahrenheit(-40), -40); // حالة خاصة
    });

    test('Fahrenheit to Celsius conversion is correct', () {
      expect(fahrenheitToCelsius(32).round(), 0);
      expect(fahrenheitToCelsius(77).round(), 25);
      expect(fahrenheitToCelsius(14).round(), -10);
      expect(fahrenheitToCelsius(212).round(), 100);
      expect(fahrenheitToCelsius(-40).round(), -40);
    });

    test('Round-trip conversion maintains precision', () {
      const celsius = 22.5;
      final fahrenheit = celsiusToFahrenheit(celsius);
      final backToCelsius = fahrenheitToCelsius(fahrenheit);
      expect(backToCelsius, closeTo(celsius, 0.001));
    });

    test('Handles decimal values correctly', () {
      expect(celsiusToFahrenheit(22.5), closeTo(72.5, 0.1));
      expect(fahrenheitToCelsius(72.5), closeTo(22.5, 0.1));
    });
  });

  group('WeatherData JSON parsing', () {
    test('Valid JSON is parsed correctly', () {
      final json = {
        'city': 'London',
        'temperature': 15.0,
        'description': 'Rainy',
        'humidity': 80,
        'windSpeed': 5.5,
        'icon': '🌧️',
      };

      final data = WeatherData.fromJson(json);
      expect(data.city, 'London');
      expect(data.temperatureCelsius, 15.0);
      expect(data.description, 'Rainy');
      expect(data.humidity, 80);
      expect(data.windSpeed, 5.5);
      expect(data.icon, '🌧️');
    });

    test('Malformed JSON throws exception', () {
      expect(() => WeatherData.fromJson({'city': 'Paris'}), throwsException);
      expect(() => WeatherData.fromJson(null), throwsException);
    });

    test('Incomplete JSON uses default values', () {
      final json = {
        'city': 'Cairo',
        'temperature': 30.0,
        // description, humidity, windSpeed ناقصين
      };

      final data = WeatherData.fromJson(json);
      expect(data.city, 'Cairo');
      expect(data.temperatureCelsius, 30.0);
      expect(data.description, 'N/A'); // Default value
      expect(data.humidity, 0); // Default value
      expect(data.windSpeed, 0.0); // Default value
      expect(data.icon, '❓'); // Default value
    });

    test('Handles different numeric types', () {
      final json = {
        'city': 'Tokyo',
        'temperature': 25, // int بدل double
        'humidity': 70,
        'windSpeed': 5, // int بدل double
      };

      final data = WeatherData.fromJson(json);
      expect(data.temperatureCelsius, 25.0);
      expect(data.windSpeed, 5.0);
    });

    test('Handles negative temperatures', () {
      final json = {'city': 'Antarctica', 'temperature': -30.5};

      final data = WeatherData.fromJson(json);
      expect(data.temperatureCelsius, -30.5);
    });

    test('Handles zero values', () {
      final json = {
        'city': 'Freezing City',
        'temperature': 0,
        'humidity': 0,
        'windSpeed': 0,
      };

      final data = WeatherData.fromJson(json);
      expect(data.temperatureCelsius, 0.0);
      expect(data.humidity, 0);
      expect(data.windSpeed, 0.0);
    });
  });
}
