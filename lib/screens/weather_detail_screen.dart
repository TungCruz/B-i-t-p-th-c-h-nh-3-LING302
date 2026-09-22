import 'package:flutter/material.dart';

import '../models/weather_data.dart';
import '../widgets/weather_symbol.dart';

class WeatherDetailScreen extends StatelessWidget {
  const WeatherDetailScreen({super.key, required this.weather});

  final WeatherData weather;

  @override
  Widget build(BuildContext context) {
    const sky = Color(0xFF168AAD);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: sky,
        foregroundColor: Colors.white,
        title: const Text('Chi tiết thời tiết'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ColoredBox(
              color: sky,
              child: SafeArea(
                top: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 42),
                      child: Column(
                        children: [
                          Text(
                            weather.city,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            weather.country,
                            style: const TextStyle(
                              color: Color(0xFFD7F3F7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Hero(
                            tag: 'weather-${weather.city}-${weather.country}',
                            child: WeatherSymbol(
                              condition: weather.condition,
                              size: 92,
                              bright: true,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            '${weather.temperature.toStringAsFixed(1)}°C',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 52,
                              fontWeight: FontWeight.w300,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            weather.description.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFD7F3F7),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chỉ số hiện tại',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 14),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = (constraints.maxWidth - 12) / 2;
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _MetricTile(
                                width: width,
                                icon: Icons.device_thermostat_rounded,
                                label: 'Cảm giác',
                                value:
                                    '${weather.feelsLike.toStringAsFixed(1)}°C',
                                color: const Color(0xFFF97352),
                              ),
                              _MetricTile(
                                width: width,
                                icon: Icons.water_drop_rounded,
                                label: 'Độ ẩm',
                                value: '${weather.humidity}%',
                                color: const Color(0xFF1B7DB5),
                              ),
                              _MetricTile(
                                width: width,
                                icon: Icons.air_rounded,
                                label: 'Sức gió',
                                value:
                                    '${weather.windSpeed.toStringAsFixed(2)} m/s',
                                color: const Color(0xFF288B78),
                              ),
                              _MetricTile(
                                width: width,
                                icon: Icons.speed_rounded,
                                label: 'Áp suất',
                                value: '${weather.pressure} hPa',
                                color: const Color(0xFF6D5BA8),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final double width;
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 116),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: Color(0xFF6C7588))),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
