import 'dart:math' as math;

class Random {
  static int generateRandom() {
    return math.Random().nextInt(100) + 1;
  }
}
