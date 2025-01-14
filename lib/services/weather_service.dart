import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const _apiKey = '68d5a8279c6c15b5c4aff08da3355729';
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<String> getWeather(String cityName) async {
    final url = '$_baseUrl?q=$cityName&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return '${data['main']['temp']}°C, ${data['weather'][0]['description']}';
    } else {
      throw Exception('Nie udało się pobrać pogody');
    }
  }
}
