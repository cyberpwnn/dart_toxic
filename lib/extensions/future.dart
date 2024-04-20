import 'package:flutter/widgets.dart';

extension TFuture<T> on Future<T> {
  Future<X> thenWait<X>(Future<X> next) => then((_) => next);

  Future<T> thenRun(void Function(T value) action) {
    return then((value) {
      action(value);
      return value;
    });
  }

  FutureBuilder<Widget> build(Widget Function(T) builder, {Widget? loading}) =>
      FutureBuilder<Widget>(
        future: then(builder),
        builder: (context, snap) =>
            snap.hasData ? snap.data! : loading ?? const SizedBox.shrink(),
      );
}
