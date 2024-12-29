import 'dart:convert';

import 'package:agri_app/pages/homepage.dart';
import 'package:agri_app/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/colors.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  Map<String, String> inputData = {};
  bool _isLoading = false;

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

  // Register user with firebase
  void _registerUser(BuildContext context) async {
    if (_globalKey.currentState!.validate()) {
      _globalKey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: inputData["email"]!, password: inputData["password"]!);


        if (kDebugMode) {
          print('registered: ${inputData["email"]} - is added');
        }
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => route.isFirst,);

      }
      on FirebaseException catch (e) {
        if(kDebugMode){
          print('Error: $e');
          showMessage(context, "Error Occurred. Try again");
        }

      }
      catch (e) {
        if(kDebugMode){
          print('Error: $e');
        }
      }
    }
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
                      SvgPicture.asset('assets/farmer.svg', fit: BoxFit.contain)),
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
                        "Create An Account",
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
                            child: Text("Register",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          onPressed: () {
                           _registerUser(context);
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account ?",
                            style: TextStyle(fontSize: 15.sp)),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const LoginPage()));
                            },
                            style: const ButtonStyle(
                              splashFactory: NoSplash.splashFactory,
                            ),
                            child: Text("Sign In",
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
