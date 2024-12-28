import 'package:agri_app/pages/weather/services/api_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentWeatherProvider = FutureProvider.autoDispose(
  (ref) => ApiHelper.getCurrentWeather(),
);
