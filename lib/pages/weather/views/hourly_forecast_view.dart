import 'package:agri_app/pages/weather/constants/app_colors.dart';
import 'package:agri_app/pages/weather/constants/text_styles.dart';
import 'package:agri_app/pages/weather/extensions/int.dart';
import 'package:agri_app/pages/weather/providers/get_hourly_forecast_provider.dart';
import 'package:agri_app/pages/weather/utils/get_weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HourlyForecastView extends ConsumerWidget {
  const HourlyForecastView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hourlyWeather = ref.watch(hourlyForecastProvider);

    return hourlyWeather.when(
      data: (hourlyForecast) {
        return SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: 12,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final forecast = hourlyForecast.list[index];
              return HourlyForcastTile(
                id: forecast.weather[0].id,
                hour: forecast.dt.time,
                temp: forecast.main.temp.round().toDouble(),
                isActive: index == 0,
              );
            },
          ),
        );
      },
      error: (error, stackTrace) {
        // Log the error and stack trace to the console
        print('\n\nError: $error');
        print('\n\nStackTrace: $stackTrace');
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class HourlyForcastTile extends StatelessWidget {
  const HourlyForcastTile({
    super.key,
    required this.id,
    required this.hour,
    required this.temp,
    required this.isActive,
  });

  final int id;
  final String hour;
  final double temp;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 16,
        top: 12,
        bottom: 12,
      ),
      child: Material(
        color: isActive ? AppColors.lightBlue : AppColors.lightGreen,
        borderRadius: BorderRadius.circular(15.0),
        elevation: isActive ? 8 : 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                getWeatherIcon(weatherCode: id),
                width: 50,
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hour,
                    style: const TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${temp}°',
                    style: TextStyles.h3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
