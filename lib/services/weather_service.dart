import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_data.dart';

class WeatherService {
  WeatherService({
    this.apiKey = const String.fromEnvironment(
      'OPENWEATHER_API_KEY',
      defaultValue: '4838627a7ad683c2046567aabc672c6c',
    ),
  });

  WeatherService.withClient(
    this._client, {
    this.apiKey = const String.fromEnvironment(
      'OPENWEATHER_API_KEY',
      defaultValue: '4838627a7ad683c2046567aabc672c6c',
    ),
  });

  http.Client? _client;
  final String apiKey;

  bool get isConfigured => apiKey.trim().isNotEmpty;

  Future<WeatherData> fetchCurrent(String city) async {
    if (!isConfigured) {
      throw const WeatherException(
        'Chưa có OpenWeather API key. Hãy chạy ứng dụng với '
        '--dart-define=OPENWEATHER_API_KEY=YOUR_KEY.',
      );
    }

    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': city,
      'appid': apiKey,
      'units': 'metric',
      'lang': 'vi',
    });

    try {
      final response = await (_client ??= http.Client())
          .get(uri)
          .timeout(const Duration(seconds: 12));
      final body = jsonDecode(response.body) as Map<String, dynamic>;

      switch (response.statusCode) {
        case 200:
          return WeatherData.fromOpenWeatherMap(body);
        case 401:
          throw const WeatherException(
            'API key không hợp lệ hoặc chưa được kích hoạt.',
          );
        case 404:
          throw const WeatherException('Không tìm thấy thành phố này.');
        case 429:
          throw const WeatherException(
            'Đã vượt giới hạn gọi API. Vui lòng thử lại sau.',
          );
        default:
          throw WeatherException(
            body['message']?.toString() ?? 'Không thể tải dữ liệu thời tiết.',
          );
      }
    } on WeatherException {
      rethrow;
    } on FormatException {
      throw const WeatherException('Phản hồi từ máy chủ không hợp lệ.');
    } catch (_) {
      throw const WeatherException('Không thể kết nối máy chủ thời tiết.');
    }
  }
}

class WeatherException implements Exception {
  const WeatherException(this.message);

  final String message;

  @override
  String toString() => message;
}
