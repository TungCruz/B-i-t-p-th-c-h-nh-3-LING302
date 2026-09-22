# Bài thực hành 3 - Ứng dụng dự báo thời tiết

Ứng dụng Flutter tra cứu thời tiết hiện tại bằng OpenWeatherMap, có gợi ý thành
phố khi nhập, danh sách thành phố nổi bật và màn hình chi tiết.

## Chạy ứng dụng

Chạy bằng API key mặc định đã cấu hình trong mã nguồn:

```powershell
flutter run -d chrome
```

Ghi đè bằng một OpenWeatherMap API key khác:

```powershell
flutter run -d chrome --dart-define=OPENWEATHER_API_KEY=YOUR_API_KEY
```

Có thể thay `chrome` bằng mã thiết bị Android hiển thị từ `flutter devices`.
API key được tạo tại trang tài khoản OpenWeatherMap. Ứng dụng gọi endpoint
`/data/2.5/weather` với `units=metric` và `lang=vi`.

## Kiểm tra

```powershell
flutter analyze
flutter test
flutter build apk --debug
```
