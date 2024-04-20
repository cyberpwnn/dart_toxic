import 'dart:ui';

extension XOffset on Offset {
  Size get asSize => Size(dx, dy);

  double distanceSquaredTo(Offset point) {
    double l2 = (this - point).distanceSquared;
    return l2;
  }

  Offset scalarMultiply(double scalar) => Offset(dx * scalar, dy * scalar);

  double dot(Offset other) => dx * other.dx + dy * other.dy;

  Offset flipY() => Offset(dx, -dy);

  Offset flipX() => Offset(-dx, dy);
}
