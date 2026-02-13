import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperatureC;
  final String conditionText;
  final String conditionIconUrl;

  WeatherData({
    required this.temperatureC,
    required this.conditionText,
    required this.conditionIconUrl,
  });
}

class WeatherService {
  static const String _apiKey = '94c8ed8d11bf4298a2505338261302';
  static const String _baseUrl = 'http://api.weatherapi.com/v1/current.json';

  Future<WeatherData> fetchBelgradeWeather() async {
    final uri = Uri.parse(
      '$_baseUrl?key=$_apiKey&q=Belgrade&lang=sr',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Neuspesno ucitavanje vremena');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final current = data['current'] as Map<String, dynamic>? ?? {};
    final condition = current['condition'] as Map<String, dynamic>? ?? {};

    final rawIcon = (condition['icon'] ?? '').toString();
    final iconUrl = rawIcon.startsWith('//') ? 'https:$rawIcon' : rawIcon;

    return WeatherData(
      temperatureC: (current['temp_c'] as num?)?.toDouble() ?? 0.0,
      conditionText: (condition['text'] ?? '').toString(),
      conditionIconUrl: iconUrl,
    );
  }
}
