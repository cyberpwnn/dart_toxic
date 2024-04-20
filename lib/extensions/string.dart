

import 'dart:math';

import 'package:toxic/toxic.dart';

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

  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";

  String capitalizeWords() => split(" ").map((e) => e.capitalize()).join(" ");
}