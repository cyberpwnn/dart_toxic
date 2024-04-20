import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

BehaviorSubject<String> _signalStream = BehaviorSubject<String>();

void pushSignal(String signal) => _signalStream.add(signal);

StreamSubscription<String> onSignal(String signal, void Function() callback) =>
    _signalStream
        .where((event) => event == signal)
        .listen((event) => callback());

Widget buildOnSignal(String signal, WidgetBuilder builder) =>
    StreamBuilder<String>(
      stream: _signalStream.where((event) => event == signal),
      builder: (context, _) => builder(context),
    );

class SignalBuilder extends StatelessWidget {
  final String signal;
  final WidgetBuilder builder;

  const SignalBuilder({super.key, required this.signal, required this.builder});

  @override
  Widget build(BuildContext context) => StreamBuilder<String>(
        stream: _signalStream.where((event) => event == signal),
        builder: (context, _) => builder(context),
      );
}
