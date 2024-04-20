import 'dart:math';
import 'dart:ui';

import 'package:toxic/toxic.dart';

extension XRect on Rect {
  bool fullyContains(Rect other) {
    return contains(other.topLeft) &&
        contains(other.topRight) &&
        contains(other.bottomLeft) &&
        contains(other.bottomRight);
  }

  Rect remap(Offset Function(Offset point)? remapper) => [
        remapper?.call(topLeft) ?? topLeft,
        remapper?.call(topRight) ?? topRight,
        remapper?.call(bottomRight) ?? bottomRight,
        remapper?.call(bottomLeft) ?? bottomLeft,
      ].toRect();

  /// Returns a new [Rect] if the current [Rect] is outside the [withinBounds]
  /// otherwise returns null. If the [Rect] is outside the [withinBounds] it will
  /// be adjusted to fit within the [withinBounds] maintaining the aspect ratio.
  Rect? constrain(Rect withinBounds) {
    double aspectRatio = withinBounds.width / withinBounds.height;

    double width = this.width;
    double height = this.height;
    double left = this.left;
    double top = this.top;
    bool needsAdjustment = false;

    if (width > withinBounds.width) {
      width = withinBounds.width;
      height = width / aspectRatio;
      needsAdjustment = true;
    } else if (height > withinBounds.height) {
      height = withinBounds.height;
      width = height * aspectRatio;
      needsAdjustment = true;
    }

    if (left < withinBounds.left) {
      left = withinBounds.left;
      needsAdjustment = true;
    } else if (top < withinBounds.top) {
      top = withinBounds.top;
      needsAdjustment = true;
    } else if (left + width > withinBounds.right) {
      left = withinBounds.right - width;
      needsAdjustment = true;
    } else if (top + height > withinBounds.bottom) {
      top = withinBounds.bottom - height;
      needsAdjustment = true;
    }

    return needsAdjustment ? Rect.fromLTWH(left, top, width, height) : null;
  }

  Rect inflatePercent(double percent) => Rect.fromCenter(
      center: center,
      width: width + (width * percent),
      height: height + (height * percent));

  Rect deflatePercent(double percent) => deflate(maxSide * percent);

  double get maxSide => max(width, height);

  double get minSide => min(width, height);
}
