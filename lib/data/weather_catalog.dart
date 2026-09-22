import '../models/weather_data.dart';

class CityOption {
  const CityOption(this.name, this.query, this.countryCode);

  final String name;
  final String query;
  final String countryCode;
}

class WeatherCatalog {
  WeatherCatalog._();

  static const cities = <CityOption>[
    CityOption('Hà Nội', 'Hanoi,VN', 'VN'),
    CityOption('Hồ Chí Minh', 'Ho Chi Minh City,VN', 'VN'),
    CityOption('Đà Nẵng', 'Da Nang,VN', 'VN'),
    CityOption('Hải Phòng', 'Hai Phong,VN', 'VN'),
    CityOption('Cần Thơ', 'Can Tho,VN', 'VN'),
    CityOption('Huế', 'Hue,VN', 'VN'),
    CityOption('Đà Lạt', 'Da Lat,VN', 'VN'),
    CityOption('Nha Trang', 'Nha Trang,VN', 'VN'),
    CityOption('Tokyo', 'Tokyo,JP', 'JP'),
    CityOption('Paris', 'Paris,FR', 'FR'),
    CityOption('New York', 'New York,US', 'US'),
    CityOption('London', 'London,GB', 'GB'),
    CityOption('Seoul', 'Seoul,KR', 'KR'),
    CityOption('Singapore', 'Singapore,SG', 'SG'),
  ];

  static const featured = <WeatherData>[
    WeatherData(
      city: 'Hà Nội',
      country: 'VN',
      temperature: 32,
      feelsLike: 34.4,
      description: 'bầu trời quang đãng',
      humidity: 50,
      windSpeed: 8.07,
      pressure: 1002,
      condition: 'clear',
    ),
    WeatherData(
      city: 'Hồ Chí Minh',
      country: 'VN',
      temperature: 32.8,
      feelsLike: 36.1,
      description: 'mưa nhẹ',
      humidity: 68,
      windSpeed: 4.2,
      pressure: 1005,
      condition: 'rain',
    ),
    WeatherData(
      city: 'Đà Nẵng',
      country: 'VN',
      temperature: 31,
      feelsLike: 33.2,
      description: 'bầu trời quang đãng',
      humidity: 58,
      windSpeed: 5.1,
      pressure: 1007,
      condition: 'clear',
    ),
    WeatherData(
      city: 'Tokyo',
      country: 'JP',
      temperature: 20.3,
      feelsLike: 19.8,
      description: 'mây cụm',
      humidity: 61,
      windSpeed: 3.4,
      pressure: 1014,
      condition: 'clouds',
    ),
    WeatherData(
      city: 'Paris',
      country: 'FR',
      temperature: 10.5,
      feelsLike: 9.2,
      description: 'mây cụm',
      humidity: 72,
      windSpeed: 2.7,
      pressure: 1018,
      condition: 'clouds',
    ),
    WeatherData(
      city: 'New York',
      country: 'US',
      temperature: 9.4,
      feelsLike: 7.6,
      description: 'trời quang',
      humidity: 55,
      windSpeed: 4.8,
      pressure: 1011,
      condition: 'clear',
    ),
  ];

  static List<CityOption> suggestionsFor(String input) {
    final query = normalize(input);
    if (query.isEmpty) return const [];
    return cities
        .where((city) => normalize(city.name).contains(query))
        .take(5)
        .toList();
  }

  static CityOption? findCity(String input) {
    final query = normalize(input);
    for (final city in cities) {
      if (normalize(city.name) == query || normalize(city.query) == query) {
        return city;
      }
    }
    return null;
  }

  static WeatherData? sampleFor(String input) {
    final query = normalize(input);
    for (final weather in featured) {
      if (normalize(weather.city) == query) return weather;
    }
    return null;
  }

  static String normalize(String value) {
    var result = value.trim().toLowerCase();
    const accents =
        'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩ'
        'òóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ';
    const plain =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooo'
        'uuuuuuuuuuuyyyyyd';
    for (var index = 0; index < accents.length; index++) {
      result = result.replaceAll(accents[index], plain[index]);
    }
    return result;
  }
}
