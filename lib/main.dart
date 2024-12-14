import 'package:agri_app/pages/cropfindingpage.dart';
import 'package:agri_app/pages/homepage.dart';

import 'package:agri_app/pages/loginpage.dart';
import 'package:agri_app/pages/scannerscreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize:  Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Quicksand',
            ),
            home:  const Homescreen(),
          );
        }
    );
  }
}
