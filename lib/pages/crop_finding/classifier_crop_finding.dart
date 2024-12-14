import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class CropRecommendationModel {
  late Interpreter _interpreter;

  CropRecommendationModel() {
    _loadModel();
  }

  void _loadModel() async {
    // Load the TFLite model
    _interpreter = await Interpreter.fromAsset('assets/crop_recommendation_model.tflite');
  }

  String predictCrop(List<double> input) {
    // Get input and output shapes
    var inputShape = _interpreter.getInputTensor(0).shape; // E.g., [1, 7]
    var outputShape = _interpreter.getOutputTensor(0).shape; // E.g., [1, number_of_classes]

    // Ensure the input matches the model's input shape
    if (input.length != inputShape[1]) {
      throw Exception("Invalid input length: expected ${inputShape[1]} but got ${input.length}");
    }

    // Convert input to Float32List to match TensorFlow Lite requirements
    var inputBuffer = Float32List.fromList(input);
    var inputTensor = List.generate(inputShape[0], (_) => inputBuffer);

    // Prepare the output buffer
    var outputBuffer = List.generate(outputShape[0], (_) => List.filled(outputShape[1], 0.0));

    // Run inference
    _interpreter.run(inputTensor, outputBuffer);

    // Decode the output (class probabilities)
    List<double> outputList = outputBuffer[0];
    int predictedIndex = outputList.indexWhere((element) => element == outputList.reduce((a, b) => a > b ? a : b));

    // Map index back to crop names
    List<String> cropLabels = [
      "rice", "maize", "chickpea", "kidneybeans", "pigeonpeas", "mothbeans", "mungbean", "blackgram", "lentil",
      "pomegranate", "banana", "mango", "grapes", "watermelon", "muskmelon", "apple", "orange", "papaya", "coconut",
      "cotton", "jute", "coffee"
    ];

    if (predictedIndex < 0 || predictedIndex >= cropLabels.length) {
      throw Exception("Prediction index out of range");
    }

    return cropLabels[predictedIndex];
  }
}


