import 'package:camera/camera.dart';
import 'package:image/image.dart' as imageLib;

/// ImageUtils
class ImageUtils {
  // Converts a [CameraImage] in YUV420 format to [imageLib.Image] in RGB format
  static imageLib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = imageLib.Image( width: width, height: height);

    for (int h = 0; h < height; h++) {
      for (int w = 0; w < width; w++) {
        final int uvIndex =
            uvPixelStride * (w ~/ 2) + uvRowStride * (h ~/ 2);
        final int index = h * width + w;

        final int y = cameraImage.planes[0].bytes[index];
        final int u = cameraImage.planes[1].bytes[uvIndex];
        final int v = cameraImage.planes[2].bytes[uvIndex];

        final rgb = yuv2rgb(y, u, v);

        // Convert the RGB integer to a Color object and set it in the image.
        image.setPixelRgb(w, h, rgb[0], rgb[1], rgb[2]);
      }
    }
    return image;
  }

  /// Convert a single YUV pixel to RGB
  static List<int> yuv2rgb(int y, int u, int v) {
    // Convert YUV pixel to RGB components
    int r = (y + v * 1.4075 - 179).round();
    int g = (y - u * 0.34414 - v * 0.7169 + 135).round();
    int b = (y + u * 1.779 - 227).round();

    // Clip values to 0-255
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return [r, g, b];
  }
}