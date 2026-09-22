import 'package:baithuchanh3/main.dart';
import 'package:baithuchanh3/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hiển thị gợi ý và kết quả tìm kiếm mẫu', (tester) async {
    await tester.pumpWidget(
      WeatherApp(weatherService: WeatherService(apiKey: '')),
    );

    await tester.enterText(find.byKey(const ValueKey('search-field')), 'Ha');
    await tester.pump();

    expect(find.text('Hà Nội'), findsWidgets);
    expect(find.text('Hải Phòng'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('suggestion-Hà Nội')));
    await tester.pump();

    expect(find.byKey(const ValueKey('search-result')), findsOneWidget);
  });

  testWidgets('mở màn hình chi tiết từ thành phố nổi bật', (tester) async {
    await tester.pumpWidget(
      WeatherApp(weatherService: WeatherService(apiKey: '')),
    );

    await tester.tap(find.byKey(const ValueKey('featured-Hà Nội')));
    await tester.pumpAndSettle();

    expect(find.text('Chi tiết thời tiết'), findsOneWidget);
    expect(find.text('Cảm giác'), findsOneWidget);
    expect(find.text('Độ ẩm'), findsOneWidget);
    expect(find.text('Sức gió'), findsOneWidget);
    expect(find.text('Áp suất'), findsOneWidget);
  });
}
