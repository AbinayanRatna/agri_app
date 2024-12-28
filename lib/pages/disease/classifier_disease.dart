
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'classes_disease.dart';

class ClassifierDisease {
  Interpreter? _interpreter;

  static const String modelFile = "assets/model.tflite";

  Future<void> loadModel({Interpreter? interpreter}) async {
    try {
      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            modelFile,
            options: InterpreterOptions()..threads = 4,
          );

      _interpreter!.allocateTensors();
      print("Interpreter successfully initialized.");
    } catch (e) {
      print("Error while creating interpreter: $e");
      rethrow;
    }
  }

  /// Gets the interpreter instance
  Interpreter get interpreter {
    if (_interpreter == null) {
      throw Exception("Interpreter has not been initialized. Call loadModel() first.");
    }
    return _interpreter!;
  }

  Future<DetectionClasses> predict(img.Image image) async {
    if (_interpreter == null) {
      throw Exception("Interpreter is not initialized. Please call loadModel() first.");
    }

    // Resize the image
    img.Image resizedImage = img.copyResize(image, width: 150, height: 150);

    // Prepare input image as Uint8List
    Uint8List inputBytes = Uint8List(1 * 150 * 150 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        final pixel = resizedImage.getPixel(x, y);
        inputBytes[pixelIndex++] = pixel.r.toInt(); // Red channel
        inputBytes[pixelIndex++] = pixel.g.toInt(); // Green channel
        inputBytes[pixelIndex++] = pixel.b.toInt(); // Blue channel
      }
    }

    final input = inputBytes.reshape([1, 150, 150, 3]);

    // Get the output tensor
    Tensor outputTensor = _interpreter!.getOutputTensor(0);
    List<int> outputShape = outputTensor.shape;
    Float32List outputData = Float32List(outputShape.reduce((a, b) => a * b));
    final output = outputData.reshape(outputShape);

    // Run inference
    _interpreter!.run(input, output);

    // Convert the output to a List<double>
    List<double> predictionResult =
    List.generate(output[0].length, (index) => output[0][index].toDouble());

    // Find the maximum value and its index
    double maxElement = predictionResult.reduce((a, b) => a > b ? a : b);
    int maxIndex = predictionResult.indexOf(maxElement);

    // Add a confidence threshold
    const double confidenceThreshold = 240;
    if (maxElement < confidenceThreshold) {
      return DetectionClasses.nothing; // Return a default class if confidence is low
    }

    // Return the detected class based on the index
    print(DetectionClasses.values[maxIndex]);
    print("\nmaxElement:${maxElement}");
    return DetectionClasses.values[maxIndex];
  }
}