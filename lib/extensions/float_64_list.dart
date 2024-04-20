import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

extension XFloat64List on Float64List {
  Offset transformOffset(Offset point) {
    return Offset(
      (this[0] * point.dx) + (this[4] * point.dy) + this[12],
      (this[1] * point.dx) + (this[5] * point.dy) + this[13],
    );
  }

  Rect transformRect(Rect rect) {
    final Offset topLeft = transformOffset(rect.topLeft);
    final Offset topRight = transformOffset(rect.topRight);
    final Offset bottomLeft = transformOffset(rect.bottomLeft);
    final Offset bottomRight = transformOffset(rect.bottomRight);

    double left =
        [topLeft.dx, topRight.dx, bottomLeft.dx, bottomRight.dx].reduce(min);
    double right =
        [topLeft.dx, topRight.dx, bottomLeft.dx, bottomRight.dx].reduce(max);
    double top =
        [topLeft.dy, topRight.dy, bottomLeft.dy, bottomRight.dy].reduce(min);
    double bottom =
        [topLeft.dy, topRight.dy, bottomLeft.dy, bottomRight.dy].reduce(max);

    return Rect.fromLTRB(left, top, right, bottom);
  }

  Float64List get inverted {
    double a = this[0];
    double b = this[1];
    double c = this[4];
    double d = this[5];
    double tx = this[12];
    double ty = this[13];

    double det = a * d - b * c;
    if (det == 0) {
      throw Exception('Matrix cannot be inverted because it is singular');
    }

    double invertedA = d / det;
    double invertedB = -b / det;
    double invertedC = -c / det;
    double invertedD = a / det;
    double invertedTx = (c * ty - d * tx) / det;
    double invertedTy = (b * tx - a * ty) / det;

    final Float64List invertedMatrix = Float64List(16);

    invertedMatrix[0] = invertedA;
    invertedMatrix[1] = invertedB;
    invertedMatrix[4] = invertedC;
    invertedMatrix[5] = invertedD;
    invertedMatrix[12] = invertedTx;
    invertedMatrix[13] = invertedTy;

    invertedMatrix[10] = 1;
    invertedMatrix[15] = 1;

    return invertedMatrix;
  }

  Float64List scaled(double x, double y) {
    final Float64List copy = Float64List.fromList(this);

    copy[0] *= x;
    copy[1] *= x;
    copy[4] *= y;
    copy[5] *= y;

    return copy;
  }

  Float64List translated(double x, double y) {
    final Float64List copy = Float64List.fromList(this);

    copy[12] += x;
    copy[13] += y;

    return copy;
  }

  void applyToCanvas(Canvas canvas) {
    canvas.restoreToCount(0);
    canvas.transform(this);
  }

  double get translationX => this[12];

  double get translationY => this[13];

  Offset get translation => Offset(translationX, translationY);

  double get scaleX => this[0];

  double get scaleY => this[5];

  Offset get scale => Offset(scaleX, scaleY);

  double get rotation {
    double cosTheta = this[0];
    double sinTheta = this[1];

    return atan2(sinTheta, cosTheta);
  }
}
