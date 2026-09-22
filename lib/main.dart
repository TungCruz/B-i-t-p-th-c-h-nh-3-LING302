import 'package:flutter/material.dart';

import 'screens/weather_home_screen.dart';
import 'services/weather_service.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key, this.weatherService});

  final WeatherService? weatherService;

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF14213D);
    const sky = Color(0xFF168AAD);
    const coral = Color(0xFFF97352);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dự báo thời tiết',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: sky,
          primary: sky,
          secondary: coral,
          surface: Colors.white,
          onSurface: navy,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: navy,
          displayColor: navy,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: Color(0xFF7A8499)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDCE2EA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDCE2EA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: sky, width: 2),
          ),
        ),
      ),
      home: WeatherHomeScreen(
        weatherService: weatherService ?? WeatherService(),
      ),
    );
  }
}
