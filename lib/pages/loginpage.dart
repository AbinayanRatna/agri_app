import 'dart:convert';

import 'package:agri_app/pages/homepage.dart';
import 'package:agri_app/pages/signuppage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/colors.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminLoginPage();
}

class _AdminLoginPage extends State<LoginPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  Map<String, String> inputData = {};
  bool _isLoading = false;

  Future<void> signIn(BuildContext context) async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: inputData["email"]!, password: inputData["password"] !);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen()));

    }catch(e){
      _showErrorDialog(context, "Incorrect credentials");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Log In Error',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showMessage(BuildContext context, String message) {
    double width = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: TextStyle(
                color: Colors.white,
                fontSize: width < 600 ? 15.sp : 12.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        showCloseIcon: true,
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 20.w, left: 15.w, right: 15.w),
        duration: const Duration(seconds: 5),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            width < 600
                ? SizedBox(
              height: 50.w,
            )
                : const SizedBox.shrink(),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 70.h),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Center(
                      child:
                      SvgPicture.asset('assets/logo.svg', fit: BoxFit.contain)),
                ),
              ),
            ),
            Expanded(
              flex: width < 600 ? 6 : 7,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 35.w, bottom: 20.w),
                      child: Text(
                        "Welcome to Agri",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontFamily: 'Quicksand'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40.w, right: 40.w),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(62, 188, 43,
                                0.23),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.w))),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 20.w, bottom: 10.w, right: 10.w, left: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                        BorderSide(color: primaryColor))),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Icon(Icons.mail,
                                            size: 20.w,
                                            color: Colors.grey[700])),
                                    Expanded(
                                      flex: 6,
                                      child: TextFormField(
                                        onSaved: (value) {
                                          setState(() {
                                            inputData["email"] = value!;
                                          });

                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Required';
                                          }

                                          final emailRegex = RegExp(
                                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                                          if (!emailRegex.hasMatch(value)) {
                                            return 'Enter a valid email';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(fontSize: 15.sp),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Email",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500],
                                                fontFamily: 'Quicksand')),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.w),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Icon(Icons.key,
                                              size: 20.w,
                                              color: Colors.grey[700])),
                                      Expanded(
                                        flex: 6,
                                        child: TextFormField(
                                          validator: (value) {
                                            return value == null ||
                                                value.isEmpty
                                                ? 'Required'
                                                : null;
                                          },
                                          onSaved: (value) {
                                            setState(() {
                                              inputData["password"] = value!;
                                            });
                                          },
                                          style: TextStyle(fontSize: 15.sp),
                                          obscureText: true,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Password",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[500])),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 40.w, right: 40.w, top: 20.w, bottom: 20.w),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: primaryColor,
                      )
                          : Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: primaryColor,
                              fixedSize: Size.fromWidth(
                                  MediaQuery.of(context).size.width),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.w)))),
                          child: Padding(
                            padding:
                            EdgeInsets.only(top: 13.w, bottom: 13.w),
                            child: Text("Login",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          onPressed: () {
                            if (_globalKey.currentState!.validate()) {
                              _globalKey.currentState!.save();
                              signIn(context);
                            }
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account ?",
                            style: TextStyle(fontSize: 15.sp)),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const SignupPage()));
                            },
                            style: const ButtonStyle(
                              splashFactory: NoSplash.splashFactory,
                            ),
                            child: Text("Sign Up",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            width > 600
                ? Expanded(
              flex: 1,
              child: Container(),
            )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
