import 'package:camera/camera.dart';

class BrightnessService {
  static double computeRoiBrightness(CameraImage image) {
    final plane = image.planes[0];
    final bytes = plane.bytes;
    final w = image.width, h = image.height;
    final roiW = (w * 0.2).toInt();
    final roiH = (h * 0.2).toInt();
    final startX = (w - roiW) ~/ 2;
    final startY = (h - roiH) ~/ 2;

    int sum = 0, count = 0;
    for (int y = startY; y < startY + roiH; y++) {
      for (int x = startX; x < startX + roiW; x++) {
        final index = y * plane.bytesPerRow + x;
        if (index < bytes.length) {
          sum += bytes[index];
          count++;
        }
      }
    }
    return count > 0 ? sum / count : 0;
  }
}
