import 'dart:math';
import 'dart:ui';

extension XIterableRect on Iterable<Rect> {
  Rect toRect() {
    if (isEmpty) {
      return Rect.zero;
    }

    if (length == 1) {
      return first;
    }

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (Rect rect in this) {
      minX = min(minX, rect.left);
      minY = min(minY, rect.top);
      maxX = max(maxX, rect.right);
      maxY = max(maxY, rect.bottom);
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}
