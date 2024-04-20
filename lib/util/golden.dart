import 'dart:math';

const double phiScaled = 1.618;

Iterable<double> goldenPowerStream() sync* {
  double currentValue = 0;

  while (true) {
    yield currentValue;
    currentValue = (currentValue + phiScaled) % 1;
  }
}

Iterable<double> goldenDegreeStream() sync* {
  yield* goldenPowerStream().map((e) => e * 360.0);
}

Iterable<double> goldenRadianStream() sync* {
  double r = pi * 2;
  yield* goldenPowerStream().map((e) => e * r);
}
