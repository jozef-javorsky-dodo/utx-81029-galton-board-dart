import 'dart:io';
import 'dart:math';
import 'package:image/image.dart';

Future<void> main() async {
  const int boardWidth = 1000;
  const int boardHeight = 600;
  const int numberOfBalls = 50000;
  const String imagePath = 'galton_board_simulation.png';

  final galtonBoard = GaltonBoard(
    width: boardWidth,
    height: boardHeight,
    numberOfBalls: numberOfBalls,
  );

  galtonBoard.runSimulation();

  final image = galtonBoard.generateImage();

  await File(imagePath).writeAsBytes(encodePng(image));

  print('Galton Board simulation completed. Image saved to: $imagePath');
}

class GaltonBoard {
  final int width;
  final int height;
  final int numberOfBalls;
  final List<int> binFrequencies;
  final Random random;

  GaltonBoard({
    required this.width,
    required this.height,
    required this.numberOfBalls,
  })  : binFrequencies = List<int>.filled(width, 0),
        random = Random();

  void runSimulation() {
    for (int i = 0; i < numberOfBalls; i++) {
      binFrequencies[_simulateSingleBallDrop()]++;
    }
  }

  Image generateImage() {
    final image = Image(width, height)..fill(getColor(102, 51, 153));

    _drawHistogram(image);

    return image;
  }

  void _drawHistogram(Image image) {
    final maxFrequency = binFrequencies.reduce(max);

    final barWidth = width ~/ binFrequencies.length;

    for (int binIndex = 0; binIndex < binFrequencies.length; binIndex++) {
      final barHeight =
          (binFrequencies[binIndex] / maxFrequency * height).toInt();

      for (int y = 0; y < barHeight; y++) {
        for (int x = 0; x < barWidth; x++) {
          final pixelX = binIndex * barWidth + x;

          final pixelY = height - y - 1;

          image.setPixelRgba(
            pixelX,
            pixelY,
            pixelX < width ~/ 2 ? 122 : 122,
            pixelX < width ~/ 2 ? 122 : 244,
            pixelX < width ~/ 2 ? 244 : 122,
            255,
          );
        }
      }
    }
  }

  int _simulateSingleBallDrop() {
    int binIndex = width ~/ 2;

    for (int row = 0; row < height; row++) {
      binIndex += random.nextInt(2) == 0 ? -1 : 1;
    }

    return binIndex.clamp(0, width - 1);
  }
}
