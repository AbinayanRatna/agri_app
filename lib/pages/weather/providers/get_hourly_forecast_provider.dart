import 'package:agri_app/pages/weather/models/hourly_weather.dart';
import 'package:agri_app/pages/weather/services/api_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hourlyForecastProvider = FutureProvider.autoDispose<HourlyWeather>(
  (ref) => ApiHelper.getHourlyForecast(),
);
