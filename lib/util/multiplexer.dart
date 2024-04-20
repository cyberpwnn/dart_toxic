import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:toxic/extensions/iterable.dart';

class Multiplexer<O> {
  final List<Stream<dynamic>> inputs;
  late List<StreamSubscription<dynamic>> _subscriptions;
  final List<dynamic> buffer = [];
  final BehaviorSubject<O> stream = BehaviorSubject();
  final O Function(List<dynamic> buffer) mapper;

  Multiplexer(this.inputs, this.mapper) {
    _subscriptions = inputs
        .mapIndexed((input, i) => input.listen((event) => _onData(event, i)))
        .toList();
  }

  void _onData(dynamic data, int index) {
    buffer[index] = data;
    stream.add(mapper(buffer));
  }

  void close() {
    _subscriptions.forEach((sub) => sub.cancel());
    stream.close();
  }
}
