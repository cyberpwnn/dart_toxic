import 'dart:math';

import 'package:flutter/widgets.dart';

class Grids {
  static SliverGridDelegate softSize(BuildContext context, double size,
          {double childAspectRatio = 1,
          double crossAxisSpacing = 0,
          double mainAxisSpacing = 0,
          int minimumCrossAxisCount = 1,
          int Function(double size)? countComputer}) =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: max(
            (countComputer?.call(MediaQuery.of(context).size.width) ??
                MediaQuery.of(context).size.width ~/ size),
            minimumCrossAxisCount),
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      );
}
