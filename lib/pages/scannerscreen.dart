import 'package:agri_app/constants/colors.dart';
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
  String outputFinal="";
  String outputFinal2="";
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
        if(detected.label=="mosaic_virus"){
          outputFinal="Mosaic virus";
          outputFinal2="There is no cure for a plant that has a mosaic virus, so the best management solution is to prevent the spread of the disease. This can be done by disinfecting tools used in cultivation, such as plastic containers and razor blades.";
        }else if(detected.label=="Tomato_Bacterial_Spot"){
          outputFinal="Tomato Bacterial Spot";
          outputFinal2="To prevent bacterial spot, you can Use certified disease-free seeds and transplants, Avoid overhead watering, Space plants adequately, with at least 18–24 inches between tomato plants, Avoid high-pressure sprays ";
        }else if(detected.label=="leaf_mold"){
          outputFinal="Tomato leaf mold";
          outputFinal2="Copper products can help treat tomato leaf mold. Some copper hydroxide formulations are approved for organic use. Destroying crop residue and sanitizing the area can help reduce the number of sclerotia and inoculum load ";
        }else if(detected.label=="early_blight"){
          outputFinal="Tomato early blight";
          outputFinal2="To control early blight, you can Increase air circulation by providing adequate spacing between plants, Remove any suckers that grow from the base of the plant, Apply fungicides on a 7-14 day interval as recommended on the label. ";
        }else if(detected.label=="septoria_leaf_spot"){
          outputFinal="Septoria leaf spot";
          outputFinal2="You can control it by Removing and destroying leaves that show signs of infection to slow the spread of the disease, Pruning and removing lower leaves can help the foliage dry faster after it gets wet.";
        }else if(detected.label=="two_spotted_spider_mite"){
          outputFinal="Two spotted spider mite";
          outputFinal2="Catching the problem early can make it easier to control. Predatory mites can be released to suppress the population of TSSM. TSSM can have up to 20 generations per year. In hot, dry weather, their life cycle can be as short as two weeks.";
        }else{
          outputFinal2="";
          outputFinal="Nothing is detected";
        }
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
                    outputFinal2,
                    style:  TextStyle(
                      fontSize: 15.sp,
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