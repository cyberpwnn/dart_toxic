import 'package:intl/intl.dart';

extension TInt on int {
  double to(num to, double progress) => this + (to - this) * progress;

  String plural(String singular, [String? plural]) =>
      this == 1 ? singular : plural ?? (singular + "s");

  String format([NumberFormat? f]) =>
      (f ?? NumberFormat.decimalPattern()).format(this);

  String formatCompact() => NumberFormat.compact().format(this);

  bool get isPrime {
    if (this <= 1) return false;
    for (int i = 2; i < this; i++) {
      if (this % i == 0) return false;
    }
    return true;
  }
}
