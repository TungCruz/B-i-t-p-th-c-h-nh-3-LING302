import 'dart:convert';

import 'package:baithuchanh3/services/weather_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('gửi đúng tham số tới OpenWeatherMap và đọc phản hồi', () async {
    Uri? requestedUri;
    final client = MockClient((request) async {
      requestedUri = request.url;
      return http.Response.bytes(
        utf8.encode('''
        {
          "name": "Hanoi",
          "sys": {"country": "VN"},
          "main": {
            "temp": 30.5,
            "feels_like": 33.0,
            "humidity": 70,
            "pressure": 1006
          },
          "wind": {"speed": 2.8},
          "weather": [
            {"main": "Rain", "description": "mưa nhẹ"}
          ]
        }
      '''),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    final service = WeatherService.withClient(client, apiKey: 'test-key');

    final weather = await service.fetchCurrent('Hanoi,VN');

    expect(requestedUri?.host, 'api.openweathermap.org');
    expect(requestedUri?.path, '/data/2.5/weather');
    expect(requestedUri?.queryParameters['q'], 'Hanoi,VN');
    expect(requestedUri?.queryParameters['appid'], 'test-key');
    expect(requestedUri?.queryParameters['units'], 'metric');
    expect(requestedUri?.queryParameters['lang'], 'vi');
    expect(weather.city, 'Hanoi');
    expect(weather.temperature, 30.5);
    expect(weather.condition, 'rain');
  });

  test('báo rõ khi chưa cấu hình API key', () async {
    final service = WeatherService(apiKey: '');

    expect(
      () => service.fetchCurrent('Hanoi,VN'),
      throwsA(isA<WeatherException>()),
    );
  });
}
