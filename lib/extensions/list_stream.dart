import 'package:toxic/util/multiplexer.dart';

extension XStreamList on List<Stream<dynamic>> {
  List<Stream<dynamic>> and(Stream<dynamic> other) => [...this, other];

  Multiplexer<O> merge<O>(O Function(List<dynamic> buffer) mapper) =>
      Multiplexer(this, mapper);
}
