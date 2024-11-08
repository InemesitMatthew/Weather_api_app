import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('25b3ee740842ce3d054752f803bf4d79');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    // default to sunny
    if (mainCondition == null) return "assets/sunny.json";
    // switches the weather animation depending on the condition
    switch (mainCondition.toLowerCase()) {
      case "clouds":
        return "assets/cloud.json";
      case "mist":
        return "assets/mist.json";
      case "smoke":
        return "assets/smoke.json";
      case "haze":
        return "assets/haze.json";
      case "dust":
      case "fog":
        return "assets/fog.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "assets/rainy.json";
      case "thunderstorm":
        return "assets/thunderstorm.json";
      case "clear":
        return "assets/sunny.json";
      default:
        return "assets/sunny.json";
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(_weather?.cityName ?? "loading city..."),

            const SizedBox(height: 25),

            // animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            const SizedBox(height: 25),

            // temperature
            Text('${_weather?.temperature.round()}°C'),

            // weather condition
            Text(_weather?.mainCondition ?? ""),
          ],
        ),
      ),
    );
  }
}
