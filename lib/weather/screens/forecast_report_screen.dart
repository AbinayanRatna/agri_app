import 'package:agri_app/weather/constants/app_colors.dart';
import 'package:agri_app/weather/constants/text_styles.dart';
import 'package:agri_app/weather/extensions/datetime.dart';
import 'package:agri_app/weather/views/gradient_container.dart';
import 'package:agri_app/weather/views/hourly_forecast_view.dart';
import 'package:agri_app/weather/views/weekly_forecast_view.dart';
import 'package:flutter/material.dart';


class ForecastReportScreen extends StatelessWidget {
  const ForecastReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      children: [
        const SizedBox(height: 40),
        // Page Title
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Forecast Report',
            style: TextStyles.h1,
          ),
        ),

        const SizedBox(height: 40),

        // Today's date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today',
              style: TextStyles.h2,
            ),
            Text(
              DateTime.now().dateTime,
              style: TextStyles.subtitleText,
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Today's forecast
        const HourlyForecastView(),

        const SizedBox(height: 20),

        // Next Forecast
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Next Forecast',
              style: TextStyles.h2,
            ),
            Icon(
              Icons.calendar_month_rounded,
              color: AppColors.white,
            ),
          ],
        ),

        // Weekly forecast
        const WeeklyForecastView(),
      ],
    );
  }
}
