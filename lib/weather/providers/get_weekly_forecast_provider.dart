import 'package:agri_app/weather/models/weekly_weather.dart';
import 'package:agri_app/weather/services/api_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final weeklyForecastProvider = FutureProvider.autoDispose<WeeklyWeather>(
  (ref) => ApiHelper.getWeeklyForecast(),
);
