import 'dart:math';

final Random _random = Random();

randomBool() => _random.nextBool();

randomDouble() => _random.nextDouble();

extension XRandom on Random {
  String nextString(int length,
      {String charset =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"}) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => charset.codeUnitAt(_random.nextInt(charset.length))));
  }
}
