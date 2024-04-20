import 'package:flutter/widgets.dart';

extension XWidget on Widget {
  Widget get intrinsicHeight => IntrinsicHeight(child: this);

  Widget get intrinsicWidth => IntrinsicWidth(child: this);

  Widget get intrinsicSize => this.intrinsicHeight.intrinsicHeight;

  Widget get centered => Center(child: this);

  Widget get expanded => Expanded(child: this);

  Widget get safeArea => SafeArea(child: this);

  Widget get scrollable => SingleChildScrollView(child: this);

  Widget get flexible => Flexible(child: this);

  Widget get scrollableHorizontal => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: this,
      );

  Widget sized({double? width, double? height}) => SizedBox(
        width: width,
        height: height,
        child: this,
      );

  Widget padLeft(double value) => Padding(
        padding: EdgeInsets.only(left: value),
        child: this,
      );

  Widget padTop(double value) => Padding(
        padding: EdgeInsets.only(top: value),
        child: this,
      );

  Widget padRight(double value) => Padding(
        padding: EdgeInsets.only(right: value),
        child: this,
      );

  Widget padBottom(double value) => Padding(
        padding: EdgeInsets.only(bottom: value),
        child: this,
      );

  Widget pad(double all) => Padding(padding: EdgeInsets.all(all), child: this);

  Widget padOnly(
          {double left = 0,
          double top = 0,
          double right = 0,
          double bottom = 0}) =>
      Padding(
          padding: EdgeInsets.only(
              left: left, top: top, right: right, bottom: bottom),
          child: this);
}
