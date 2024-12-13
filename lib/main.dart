import 'package:agri_app/pages/homepage.dart';
import 'package:agri_app/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize:  Size(375, 812), // Set according to your design specs
        minTextAdapt: true, // Enable minimum text adaptation
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            theme: ThemeData(
              fontFamily: 'Quicksand',
            ),
            home: const Homescreen(),
          );
        }
    );
  }
}
