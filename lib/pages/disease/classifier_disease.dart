import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'classes_disease.dart';

class ClassifierDisease {
  Interpreter? _interpreter;

  static const String modelFile = "assets/rock_paper_scissors_model.tflite";

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

    img.Image resizedImage = img.copyResize(image, width: 150, height: 150);

    // Convert the resized image to a 1D Float32List.
    Float32List inputBytes = Float32List(1 * 150 * 150 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        final pixel = resizedImage.getPixel(x, y); // `pixel` is a Pixel object.
        inputBytes[pixelIndex++] = pixel.r / 127.5 - 1.0; // Red channel
        inputBytes[pixelIndex++] = pixel.g / 127.5 - 1.0; // Green channel
        inputBytes[pixelIndex++] = pixel.b / 127.5 - 1.0; // Blue channel
      }
    }

    final output = Float32List(1 * 4).reshape([1, 4]);

    final input = inputBytes.reshape([1, 150, 150, 3]);

    interpreter.run(input, output);

    final predictionResult = output[0] as List<double>;
    double maxElement = predictionResult.reduce(
          (double maxElement, double element) =>
      element > maxElement ? element : maxElement,
    );
    return DetectionClasses.values[predictionResult.indexOf(maxElement)];
  }
}
