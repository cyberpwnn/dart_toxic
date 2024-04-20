import 'dart:ui';

extension XColor on Color {
  String get hex => "#${value.toRadixString(16).padLeft(8, '0').substring(2)}";

  String get hexRGB =>
      "#${value.toRadixString(16).padLeft(8, '0').substring(6)}";

  Color lerp(Color a, double t) {
    return Color.lerp(this, a, t)!;
  }
}
