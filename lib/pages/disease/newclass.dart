import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteModelService {
  Interpreter? _interpreter;

  /// Loads the TFLite model from assets.
  Future<void> loadModel() async {
    String modelPath = 'assets/model.tflite';
    try {
      ByteData data = await rootBundle.load(modelPath);
      print("Model asset loaded successfully. Size: ${data.lengthInBytes} bytes");
    } catch (e) {
      print("Error loading model asset: $e");
      throw Exception("Failed to load the asset for the model at $modelPath.");
    }

    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      print("TFLite model loaded successfully.");
    } catch (e) {
      print("Error initializing TFLite interpreter: $e");
      throw Exception("Failed to initialize the TFLite interpreter. Ensure the model file exists and is declared in pubspec.yaml.");
    }
  }

  /// Checks if the model is successfully loaded.
  bool isModelLoaded() => _interpreter != null;

  /// Runs inference on the provided preprocessed image.
  Future<List<dynamic>> runInference(Uint8List inputImage) async {
    if (_interpreter == null) {
      throw Exception("TFLite interpreter is not initialized.");
    }

    // Retrieve the input and output tensor shapes
    final inputShape = _interpreter!.getInputTensor(0).shape; // [1, 224, 224, 3]
    final outputShape = _interpreter!.getOutputTensor(0).shape; // Example: [1, 6]

    print("Input Shape: $inputShape");
    print("Output Shape: $outputShape");

    // Verify the input size matches the model's expected size
    final expectedInputSize = inputShape[1] * inputShape[2] * inputShape[3];
    if (inputImage.length != expectedInputSize) {
      throw Exception("Input image size (${inputImage.length}) does not match the model's expected size ($expectedInputSize). Ensure preprocessing is correct.");
    }

    // Prepare the input buffer
    final input = List.generate(
      inputShape[1],
          (_) => List.generate(
        inputShape[2],
            (_) => List.generate(
          inputShape[3],
              (_) => 0.0,
        ),
      ),
    ).reshape([1, inputShape[1], inputShape[2], inputShape[3]]);

    // Populate input tensor with normalized image data
    for (int i = 0; i < inputShape[1]; i++) {
      for (int j = 0; j < inputShape[2]; j++) {
        for (int k = 0; k < inputShape[3]; k++) {
          int pixelIndex = ((i * inputShape[2]) + j) * inputShape[3] + k;
          input[0][i][j][k] = inputImage[pixelIndex] / 255.0; // Normalize pixel values to [0, 1]
        }
      }
    }

    // Prepare the output buffer
    final output = List.generate(outputShape.reduce((a, b) => a * b), (_) => 0.0).reshape(outputShape);

    // Perform inference
    _interpreter!.run(input, output);

    print("Raw Output: $output");

    return output;
  }

  /// Releases the interpreter resources.
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    print("TFLite interpreter resources released.");
  }
}
