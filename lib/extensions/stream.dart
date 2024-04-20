
import 'package:flutter/widgets.dart';

extension XStream<T> on Stream<T> {
  StreamBuilder<T> build(Widget Function(T) builder, {Widget? loading}) =>
      StreamBuilder<T>(
        stream: this,
        builder: (context, snap) => snap.hasData
            ? builder(snap.data!)
            : loading ?? const SizedBox.shrink(),
      );
}
