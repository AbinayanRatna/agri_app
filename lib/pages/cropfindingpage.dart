import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import 'crop_finding/classifier_crop_finding.dart';

class CropFindingPage extends StatefulWidget {
  const CropFindingPage({super.key});

  @override
  State<StatefulWidget> createState() => CropFindingPageState();
}

class CropFindingPageState extends State<CropFindingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp _numberRegex = RegExp(r'^(?:-?\d+|\d*\.\d+)$');
  List<dynamic>? _output;
  bool _loading=false;
  List<double> inputs=[0,0,0,0,0,0,0];

  String _prediction = "";
  final CropRecommendationModel _model = CropRecommendationModel();
  Future<void> _predictCrop(List<double> inputs) async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
    String result = _model.predictCrop(inputs);
    print("result : $result");
    print(inputs);
    setState(() {
      _prediction = result;
    });
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: true,
        title: const Text(
          'Find the Crop',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    onSaved: (value) {
                      setState(() {
                        inputs[0]=(double.parse(value!));
                      });

                    },
                    validator: (value) {
                      if (!_numberRegex.hasMatch(value!)) {
                        return 'Invalid number format';
                      }
                      return value == "" ? "Required" : null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Ratio of Nitrogen content in soil",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.w),
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          inputs[1]=double.parse(value!);
                        });

                      },
                      validator: (value) {
                        if (!_numberRegex.hasMatch(value!)) {
                          return 'Invalid number format';
                        }
                        return value == "" ? "Required" : null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Ratio of Phosphorous content in soil",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.w),
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          inputs[2]=double.parse(value!);
                        });

                      },
                      validator: (value) {
                        if (!_numberRegex.hasMatch(value!)) {
                          return 'Invalid number format';
                        }
                        return value == "" ? "Required" : null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Ratio of Potassium content in soil",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.w),
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          inputs[3]=double.parse(value!);
                        });

                      },
                      validator: (value) {
                        if (!_numberRegex.hasMatch(value!)) {
                          return 'Invalid number format';
                        }
                        return value == "" ? "Required" : null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Temperature (deg Cel)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.w),
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          inputs[4]=double.parse(value!);
                        });

                      },
                      validator: (value) {
                        if (!_numberRegex.hasMatch(value!)) {
                          return 'Invalid number format';
                        }
                        return value == "" ? "Required" : null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Relative humidity in %",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.w),
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          inputs[5]=double.parse(value!);
                        });

                      },
                      validator: (value) {
                        if (!_numberRegex.hasMatch(value!)) {
                          return 'Invalid number format';
                        }
                        return value == "" ? "Required" : null;
                      },
                      decoration: const InputDecoration(
                        labelText: "PH of soil",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.w),
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          inputs[6]=double.parse(value!);
                        });

                      },
                      validator: (value) {
                        if (!_numberRegex.hasMatch(value!)) {
                          return 'Invalid number format';
                        }
                        return value == "" ? "Required" : null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Average Rainfall (mm)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top:15.w),
                    child: ElevatedButton(
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();

                          await _predictCrop(inputs);

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width, 50.w),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w)))
                      ),
                      child: Center(
                        child: Text(
                          "Find Crop",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15.sp),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top:15.w),
                    child: Container(
                      width: width,
                      height: 100.w,
                      decoration:  BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.w)),
                          border: Border.all(color:primaryColor,width: 2.w )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Text(
                              "Proper Crops : ",
                              style: TextStyle(
                                  color: primaryColorLowOpacity,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp),
                            ),
                          ),
                          Center(
                            child: Text(
                              _prediction!=null?"$_prediction":"No Crops Found",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}