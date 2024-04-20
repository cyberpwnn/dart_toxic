import 'dart:ui';

extension XPath on Path {
  void move(Offset offset) => moveTo(offset.dx, offset.dy);

  void line(Offset offset) => lineTo(offset.dx, offset.dy);
}
