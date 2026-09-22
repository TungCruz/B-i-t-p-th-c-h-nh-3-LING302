import 'package:flutter/material.dart';

import '../data/weather_catalog.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';
import 'weather_detail_screen.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key, required this.weatherService});

  final WeatherService weatherService;

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  List<WeatherData> _featured = List.of(WeatherCatalog.featured);
  List<CityOption> _suggestions = const [];
  WeatherData? _searchResult;
  String? _message;
  bool _loadingFeatured = false;
  bool _searching = false;
  bool _usingLiveData = false;

  @override
  void initState() {
    super.initState();
    if (widget.weatherService.isConfigured) {
      _refreshFeatured();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _refreshFeatured() async {
    if (!widget.weatherService.isConfigured || _loadingFeatured) return;
    setState(() {
      _loadingFeatured = true;
      _message = null;
    });

    final updated = <WeatherData>[];
    var successfulRequests = 0;
    WeatherException? lastError;
    for (var index = 0; index < WeatherCatalog.featured.length; index++) {
      final sample = WeatherCatalog.featured[index];
      final option = WeatherCatalog.findCity(sample.city);
      try {
        updated.add(
          await widget.weatherService.fetchCurrent(
            option?.query ?? sample.city,
          ),
        );
        successfulRequests++;
      } on WeatherException catch (error) {
        updated.add(sample);
        lastError = error;
      }
    }

    if (!mounted) return;
    setState(() {
      _featured = updated;
      _loadingFeatured = false;
      _usingLiveData = successfulRequests > 0;
      _message = successfulRequests == 0 ? lastError?.message : null;
    });
  }

  void _onQueryChanged(String value) {
    setState(() {
      _suggestions = WeatherCatalog.suggestionsFor(value);
      _message = null;
    });
  }

  void _selectSuggestion(CityOption city) {
    _searchController.text = city.name;
    _searchController.selection = TextSelection.collapsed(
      offset: city.name.length,
    );
    setState(() => _suggestions = const []);
    _searchFocus.unfocus();
    _search();
  }

  Future<void> _search() async {
    final input = _searchController.text.trim();
    if (input.isEmpty || _searching) {
      if (input.isEmpty) {
        setState(() => _message = 'Vui lòng nhập tên thành phố.');
      }
      return;
    }

    _searchFocus.unfocus();
    setState(() {
      _suggestions = const [];
      _searching = true;
      _message = null;
    });

    if (!widget.weatherService.isConfigured) {
      final sample = WeatherCatalog.sampleFor(input);
      if (!mounted) return;
      setState(() {
        _searchResult = sample;
        _searching = false;
        _message = sample == null
            ? 'Thành phố này cần OpenWeather API key để tra cứu.'
            : null;
      });
      return;
    }

    final option = WeatherCatalog.findCity(input);
    try {
      final result = await widget.weatherService.fetchCurrent(
        option?.query ?? input,
      );
      if (!mounted) return;
      setState(() {
        _searchResult = result;
        _searching = false;
      });
    } on WeatherException catch (error) {
      if (!mounted) return;
      setState(() {
        _searchResult = null;
        _searching = false;
        _message = error.message;
      });
    }
  }

  void _openDetails(WeatherData weather) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WeatherDetailScreen(weather: weather),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        title: const Text(
          'Dự báo thời tiết',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: widget.weatherService.isConfigured && !_loadingFeatured
                ? _refreshFeatured
                : null,
            tooltip: 'Làm mới dữ liệu',
            icon: _loadingFeatured
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
              children: [
                Text(
                  'Hôm nay trời thế nào?',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Tìm thành phố để xem nhiệt độ và các chỉ số mới nhất.',
                  style: TextStyle(color: Color(0xFF6C7588)),
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        key: const ValueKey('search-field'),
                        controller: _searchController,
                        focusNode: _searchFocus,
                        textInputAction: TextInputAction.search,
                        onChanged: _onQueryChanged,
                        onSubmitted: (_) => _search(),
                        decoration: InputDecoration(
                          hintText: 'Nhập tên thành phố (vd: Hà Nội)',
                          prefixIcon: const Icon(Icons.location_city_rounded),
                          suffixIcon: _searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _suggestions = const [];
                                      _searchResult = null;
                                      _message = null;
                                    });
                                  },
                                  tooltip: 'Xóa nội dung',
                                  icon: const Icon(Icons.close_rounded),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox.square(
                      dimension: 56,
                      child: FilledButton(
                        key: const ValueKey('search-button'),
                        onPressed: _searching ? null : _search,
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _searching
                            ? const SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.search_rounded),
                      ),
                    ),
                  ],
                ),
                if (_suggestions.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xFFDCE2EA)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (final city in _suggestions)
                          ListTile(
                            key: ValueKey('suggestion-${city.name}'),
                            dense: true,
                            leading: const Icon(Icons.place_outlined, size: 20),
                            title: Text(city.name),
                            trailing: Text(
                              city.countryCode,
                              style: const TextStyle(color: Color(0xFF7A8499)),
                            ),
                            onTap: () => _selectSuggestion(city),
                          ),
                      ],
                    ),
                  ),
                ],
                if (_message != null) ...[
                  const SizedBox(height: 12),
                  _StatusMessage(message: _message!),
                ],
                if (_searchResult != null) ...[
                  const SizedBox(height: 22),
                  const _SectionTitle(
                    title: 'Kết quả tìm kiếm',
                    icon: Icons.manage_search_rounded,
                  ),
                  const SizedBox(height: 10),
                  WeatherCard(
                    key: const ValueKey('search-result'),
                    weather: _searchResult!,
                    highlighted: true,
                    onTap: () => _openDetails(_searchResult!),
                  ),
                ],
                const SizedBox(height: 26),
                _SectionTitle(
                  title: 'Thành phố nổi bật',
                  icon: Icons.star_rounded,
                  trailing: _usingLiveData
                      ? 'Dữ liệu trực tuyến'
                      : 'Dữ liệu mẫu',
                ),
                const SizedBox(height: 10),
                for (final weather in _featured) ...[
                  WeatherCard(
                    key: ValueKey('featured-${weather.city}'),
                    weather: weather,
                    onTap: () => _openDetails(weather),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon, this.trailing});

  final String title;
  final IconData icon;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(
              color: Color(0xFF6C7588),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF4C47A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF9A6412)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFF68450E)),
            ),
          ),
        ],
      ),
    );
  }
}
