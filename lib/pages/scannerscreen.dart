import 'package:agri_app/constants/colors.dart';
import 'package:agri_app/constants/diagnosis.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tflite_flutter/tflite_flutter.dart';

import 'disease/classes_disease.dart';
import 'disease/classifier_disease.dart';
import 'disease/imageutils.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late CameraController cameraController;
  late Interpreter interpreter;
  final classifier = ClassifierDisease();

  bool initialized = false;
  DetectionClasses detected = DetectionClasses.nothing;
  DateTime lastShot = DateTime.now();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await classifier.loadModel();

    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );

    // Initialize the CameraController and start the camera preview
    await cameraController.initialize();
    // Listen for image frames
    await cameraController.startImageStream((image) {
      // Make predictions every 1 second to avoid overloading the device
      if (DateTime.now().difference(lastShot).inSeconds > 1) {
        processCameraImage(image);
      }
    });

    setState(() {
      initialized = true;
    });
  }

  Future<void> processCameraImage(CameraImage cameraImage) async {
    final convertedImage = ImageUtils.convertYUV420ToImage(cameraImage);

    final result = await classifier.predict(convertedImage);

    if (detected != result) {
      setState(() {
        detected = result;
      });
    }

    lastShot = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: true,
        title: const Text('Disease Detection',style: TextStyle(color: Colors.white),),
      ),
      body: initialized
          ? Padding(
              padding: EdgeInsets.only(
                  top: 10.w, left: 10.w, right: 10.w, bottom: 10.w),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: CameraPreview(cameraController),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.w),
                    child: Container(
                      width: width,
                      height: 80.w,
                      decoration:  BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.w)),
                        border: Border.all(color:primaryColor,width: 2.w )
                      ),
                      child: Center(
                        child: Text(
                          detected.label,
                          style:  TextStyle(
                            fontSize: 20.sp,
                            color: primaryColorLowOpacity,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.w),
                    child: Container(
                      width: width,
                      height: 160.w,
                      decoration:  BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.w)),
                          border: Border.all(color:primaryColor,width: 2.w )
                      ),
                      child: Center(
                        child: Text(
                          diagnosis1,
                          style:  TextStyle(
                            fontSize: 20.sp,
                            color: primaryColorLowOpacity,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
