import 'dart:math';

import 'package:intl/intl.dart';

extension TDouble on double {
  double centerOnBit(int bitDepth) =>
      ((floor() >> bitDepth) << bitDepth) + (1 << (bitDepth - 1)).toDouble();

  double roundToNearest(int decimal) => (this * decimal).round() / decimal;

  double get deg => this * 180 / pi;

  double get rad => this * pi / 180;

  String percent([int decimals = 0]) =>
      "${(this * 100).toStringAsFixed(decimals)}%";

  String format([NumberFormat? f]) =>
      (f ?? NumberFormat.decimalPattern()).format(this);

  String get formatCompact => NumberFormat.compact().format(this);

  /// Lerp this, to the given value, by the given progress.
  double lerpTo(double to, double progress) => this + (to - this) * progress;
}
