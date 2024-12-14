import 'package:agri_app/constants/colors.dart';
import 'package:agri_app/weather/constants/app_colors.dart';
import 'package:agri_app/weather/screens/forecast_report_screen.dart';
import 'package:agri_app/weather/services/api_helper.dart';
import 'package:flutter/material.dart';
import 'weather_screen/weather_screen.dart';

class HomeScreenWeather extends StatefulWidget {
  const HomeScreenWeather({super.key});

  @override
  State<HomeScreenWeather> createState() => _HomeScreenWeatherState();
}

class _HomeScreenWeatherState extends State<HomeScreenWeather> {
  int _currentPageIndex = 0;

  final _screens = const [
    WeatherScreen(),
    ForecastReportScreen(),
  ];

  @override
  void initState() {
    ApiHelper.getCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentPageIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          backgroundColor: Color.fromRGBO(7, 34, 3, 1.0),
        ),
        child: NavigationBar(
          selectedIndex: _currentPageIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          indicatorColor: Colors.transparent,
          onDestinationSelected: (index) =>
              setState(() => _currentPageIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.home, color: Colors.white),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.wb_sunny_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.wb_sunny, color: Colors.white),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
