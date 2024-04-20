import 'dart:ui';

extension XSize on Size {
  Offset get asOffset => Offset(width, height);

  Rect toRect([Offset? offset]) => Rect.fromCenter(
      center: offset ?? Offset.zero, width: width, height: height);

  Size operator /(double factor) => Size(width / factor, height / factor);

  Size operator *(double factor) => Size(width * factor, height * factor);
}
