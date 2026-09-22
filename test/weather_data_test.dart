import 'dart:convert';

import 'package:baithuchanh3/models/weather_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ánh xạ phản hồi OpenWeatherMap', () {
    final json = jsonDecode('''
      {
        "name": "Hanoi",
        "sys": {"country": "VN"},
        "main": {
          "temp": 31.2,
          "feels_like": 34.1,
          "humidity": 64,
          "pressure": 1008
        },
        "wind": {"speed": 3.6},
        "weather": [
          {"main": "Clouds", "description": "mây rải rác"}
        ]
      }
    ''') as Map<String, dynamic>;

    final weather = WeatherData.fromOpenWeatherMap(json);

    expect(weather.city, 'Hanoi');
    expect(weather.temperature, 31.2);
    expect(weather.humidity, 64);
    expect(weather.condition, 'clouds');
    expect(weather.description, 'mây rải rác');
  });
}
