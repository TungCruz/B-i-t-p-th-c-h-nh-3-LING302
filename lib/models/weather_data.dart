class WeatherData {
  const WeatherData({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.condition,
  });

  factory WeatherData.fromOpenWeatherMap(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>?;
    final wind = json['wind'] as Map<String, dynamic>?;
    final system = json['sys'] as Map<String, dynamic>?;
    final weather = json['weather'] as List<dynamic>?;
    final firstWeather = weather?.isNotEmpty == true
        ? weather!.first as Map<String, dynamic>
        : <String, dynamic>{};

    if (main == null || wind == null || json['name'] == null) {
      throw const FormatException('Dữ liệu thời tiết không đầy đủ.');
    }

    return WeatherData(
      city: json['name'].toString(),
      country: system?['country']?.toString() ?? '',
      temperature: _number(main['temp']),
      feelsLike: _number(main['feels_like']),
      description: firstWeather['description']?.toString() ?? 'Không xác định',
      humidity: _number(main['humidity']).round(),
      windSpeed: _number(wind['speed']),
      pressure: _number(main['pressure']).round(),
      condition: firstWeather['main']?.toString().toLowerCase() ?? 'unknown',
    );
  }

  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final String description;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String condition;

  static double _number(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
