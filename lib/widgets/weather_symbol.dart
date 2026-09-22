import 'package:flutter/material.dart';

class WeatherSymbol extends StatelessWidget {
  const WeatherSymbol({
    super.key,
    required this.condition,
    this.size = 48,
    this.bright = false,
  });

  final String condition;
  final double size;
  final bool bright;

  @override
  Widget build(BuildContext context) {
    final visual = _visualFor(condition);
    final background = bright
        ? Colors.white.withValues(alpha: 0.2)
        : visual.color.withValues(alpha: 0.14);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: background),
      alignment: Alignment.center,
      child: Icon(
        visual.icon,
        size: size * 0.56,
        color: bright ? Colors.white : visual.color,
      ),
    );
  }

  _WeatherVisual _visualFor(String value) {
    final condition = value.toLowerCase();
    if (condition.contains('thunder')) {
      return const _WeatherVisual(
        Icons.thunderstorm_rounded,
        Color(0xFF6D5BA8),
      );
    }
    if (condition.contains('rain') || condition.contains('drizzle')) {
      return const _WeatherVisual(Icons.water_drop_rounded, Color(0xFF1B7DB5));
    }
    if (condition.contains('snow')) {
      return const _WeatherVisual(Icons.ac_unit_rounded, Color(0xFF4A90A4));
    }
    if (condition.contains('cloud')) {
      return const _WeatherVisual(Icons.cloud_rounded, Color(0xFF667085));
    }
    if (condition.contains('mist') ||
        condition.contains('fog') ||
        condition.contains('haze')) {
      return const _WeatherVisual(Icons.air_rounded, Color(0xFF7A8499));
    }
    return const _WeatherVisual(Icons.wb_sunny_rounded, Color(0xFFF97352));
  }
}

class _WeatherVisual {
  const _WeatherVisual(this.icon, this.color);

  final IconData icon;
  final Color color;
}
