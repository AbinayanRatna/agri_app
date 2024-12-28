import 'dart:ui';
import 'package:agri_app/pages/loginpage.dart';
import 'package:agri_app/pages/market/market.dart';
import 'package:agri_app/pages/scannerscreen.dart';
import 'package:agri_app/pages/weather/screens/home_screen_weather.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';
import 'cropfindingpage.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => HomescreenState();
}

class HomescreenState extends State<Homescreen> {
  late CarouselSliderController controller;

  @override
  void initState() {
    controller = CarouselSliderController();
    super.initState();
  }

  final List<Widget> imageAddress = [
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
        color: Colors.purpleAccent,
      ),
      margin: EdgeInsets.only(left: 15.w),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
        child: Image.asset(
          "assets/img2.jpeg",
          fit: BoxFit.fill,
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
        color: Colors.purpleAccent,
      ),
      margin: EdgeInsets.only(left: 15.w),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
        child: Image.asset(
          "assets/img4.png",
          fit: BoxFit.fill,
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
        color: Colors.pinkAccent,
      ),
      margin: EdgeInsets.only(left: 15.w),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
        child: Image.asset(
          "assets/img1.jpeg",
          fit: BoxFit.fill,
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
        color: Colors.purpleAccent,
      ),
      margin: EdgeInsets.only(left: 15.w),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
        child: Image.asset(
          "assets/img3.jpeg",
          fit: BoxFit.fill,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to disable back button
        return false;
      },
      child: ScreenUtilInit(
        minTextAdapt: true,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      "Hello Farmer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            toolbarHeight: 60.w,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 15.w, left: 10.w),
                child: InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.logout,
                      // color: Color.fromRGBO(9, 75, 75, 1.0),
                      color: Color.fromRGBO(3, 152, 175, 1.0),
                    ),
                  ),
                ),
              ),
            ],
            backgroundColor: primaryColor,
          ),
          backgroundColor: const Color.fromRGBO(236, 230, 230, 1.0),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15.w),
                        child: Container(
                          child: Center(
                            child: CarouselSlider(
                              carouselController: controller,
                              items: imageAddress,
                              options: CarouselOptions(
                                  height: MediaQuery.of(context).size.height /
                                      3.5.h,
                                  autoPlay: true,
                                  autoPlayInterval:
                                      Duration(milliseconds: 1800),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 500)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30.w, 10.w, 25.w, 0),
                          //color: Colors.blue,
                          //const Color.fromRGBO(33, 160, 164, 1.0),
                          height: MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).size.height / 1.6.w),
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio:
                                        MediaQuery.of(context).size.width < 700
                                            ? (1.1)
                                            : (1.5),
                                    mainAxisSpacing: 20.w,
                                    crossAxisSpacing: 20.w),
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScannerScreen()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        stops: [
                                          0.1.w,
                                          0.4.w,
                                          0.6.w,
                                          0.9.w,
                                        ],
                                        colors: const [
                                          Color.fromRGBO(60, 80, 35, 1.0),
                                          Color.fromRGBO(138, 182, 70, 1.0),
                                          Color.fromRGBO(138, 182, 70, 1.0),
                                          Color.fromRGBO(60, 80, 35, 1.0)
                                        ],
                                      ),
                                      //  color: Color.fromRGBO(188, 197, 197, 1.0),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.w),
                                          topLeft: Radius.circular(20.w),
                                          bottomRight: Radius.circular(20.w),
                                          bottomLeft: Radius.circular(20.w))),
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10.w),
                                        child: SvgPicture.asset(
                                          "assets/leafs.svg",
                                          width: 50.w,
                                        ),
                                      ),
                                      Center(
                                          child: Text(
                                        "Disease",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp,
                                            color: Colors.white),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreenWeather()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        stops: [
                                          0.1.w,
                                          0.4.w,
                                          0.6.w,
                                          0.9.w,
                                        ],
                                        colors: const [
                                          Color.fromRGBO(60, 80, 35, 1.0),
                                          Color.fromRGBO(138, 182, 70, 1.0),
                                          Color.fromRGBO(138, 182, 70, 1.0),
                                          Color.fromRGBO(60, 80, 35, 1.0)
                                        ],
                                      ),
                                      //color: Color.fromRGBO(188, 197, 197, 1.0),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.w),
                                          topLeft: Radius.circular(20.w),
                                          bottomRight: Radius.circular(20.w),
                                          bottomLeft: Radius.circular(20.w))),
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10.w),
                                        child: SvgPicture.asset(
                                          "assets/weather.svg",
                                          width: 60.w,
                                        ),
                                      ),
                                      Center(
                                          child: Text(
                                        "Weather",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CropFindingPage()));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        // color: Color.fromRGBO(188, 197, 197, 1.0),
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          stops: [
                                            0.1.w,
                                            0.4.w,
                                            0.6.w,
                                            0.9.w,
                                          ],
                                          colors: const [
                                            Color.fromRGBO(60, 80, 35, 1.0),
                                            Color.fromRGBO(138, 182, 70, 1.0),
                                            Color.fromRGBO(138, 182, 70, 1.0),
                                            Color.fromRGBO(60, 80, 35, 1.0)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20.w),
                                            topLeft: Radius.circular(20.w),
                                            bottomRight: Radius.circular(20.w),
                                            bottomLeft: Radius.circular(20.w))),
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 10.w),
                                          child: SvgPicture.asset(
                                            "assets/search.svg",
                                            width: 50.w,
                                          ),
                                        ),
                                        Center(
                                            child: Text(
                                          "Find Crop",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp,
                                            color: Colors.white,
                                          ),
                                        )),
                                      ],
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MarketScreen()));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          stops: [
                                            0.1.w,
                                            0.4.w,
                                            0.6.w,
                                            0.9.w,
                                          ],
                                          colors: const [
                                            Color.fromRGBO(60, 80, 35, 1.0),
                                            Color.fromRGBO(138, 182, 70, 1.0),
                                            Color.fromRGBO(138, 182, 70, 1.0),
                                            Color.fromRGBO(60, 80, 35, 1.0)
                                          ],
                                        ),
                                        //color: Color.fromRGBO(188, 197, 197, 1.0),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20.w),
                                            topLeft: Radius.circular(20.w),
                                            bottomRight: Radius.circular(20.w),
                                            bottomLeft: Radius.circular(20.w))),
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 10.w),
                                          child: SvgPicture.asset(
                                            "assets/market.svg",
                                            width: 50.w,
                                          ),
                                        ),
                                        Center(
                                            child: Text(
                                          "Market",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp,
                                            color: Colors.white,
                                          ),
                                        )),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.w),
                        child: const Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("Copyrights reserved"),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
