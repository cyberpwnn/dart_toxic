import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:toxic/toxic.dart';
import 'package:toxic/util/charcodec.dart';

Random _r = Random();

extension TString on String {
  String get lowerCamelCaseToUpperSpacedCase =>
      replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
          .trim()
          .capitalizeWords();

  String get roadkill => replaceAll(" ", "_").toLowerCase();

  String get upperRoadkill => replaceAll(" ", "_").toUpperCase();

  String get dashkill => replaceAll(" ", "-").toLowerCase();

  String get upperDashkill => replaceAll(" ", "-").toUpperCase();

  String get camelCase =>
      split(" ").map((e) => e.toLowerCase().capitalize()).join();

  Uint8List get encodedUtf8 => utf8.encode(this);

  Uint8List get decodedBase64 => base64Decode(this);

  Uint8List get decodedHex {
    Uint8List result = Uint8List(length ~/ 2);
    for (int i = 0; i < length; i += 2) {
      String byte = substring(i, i + 2);
      result[i ~/ 2] = int.parse(byte, radix: 16);
    }
    return result;
  }

  Uint8List decodedWithCharset(String charset) =>
      CharCodec.decodeFromBase64(encoded: this, charset: charset).decodedBase64;

  Uint8List get decodedBundle => CharCodec.decodeBundle(this).decodedBase64;

  String randomCase() => charMap((e) => e == " "
      ? " "
      : _r.nextBool()
          ? e.toUpperCase()
          : e.toLowerCase());

  String charMap(String Function(String char) map) {
    String s = "";
    for (int i = 0; i < length; i++) {
      s += map(this[i]);
    }
    return s;
  }

  String get reversed => split("").reversed.join();

  List<String> splitSlashes() => split("/");

  List<String> splitDots() => split(".");

  String splitAfter(String separator, String key) {
    List<String> s = split(separator);
    int index = s.indexOf(key);
    if (index == -1 || index >= s.lastIndex) {
      return "";
    }
    return s[index + 1];
  }

  String splitLast(String separator) => split(separator).last;

  String capitalize() => isEmpty
      ? ""
      : length == 1
          ? this[0].toUpperCase()
          : "${this[0].toUpperCase()}${substring(1)}";

  String capitalizeWords() => split(" ").map((e) => e.capitalize()).join(" ");
}
