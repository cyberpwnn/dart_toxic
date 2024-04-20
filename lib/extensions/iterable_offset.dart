import 'dart:math';
import 'dart:ui';

extension XIterableOffset on Iterable<Offset> {
  Rect toRect() {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (Offset offset in this) {
      minX = min(minX, offset.dx);
      minY = min(minY, offset.dy);
      maxX = max(maxX, offset.dx);
      maxY = max(maxY, offset.dy);
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}
