
import 'dart:math';

import 'package:intl/intl.dart';

final NumberFormat _f = NumberFormat("#,##0");

extension XNum on num {
  String readableFileSize({bool base1024 = true}) {
    final base = base1024 ? 1024 : 1000;
    if (this <= 0) return "0";
    final units = ["B", "KB", "MB", "GB", "TB", "PB"];
    int digitGroups = 0;

    if (this > base) {
      digitGroups = 1;
    }

    if (this > pow(base, 2)) {
      digitGroups = 2;
    }

    if (this > pow(base, 3)) {
      digitGroups = 3;
    }

    if (this > pow(base, 4)) {
      digitGroups = 4;
    }

    if (this > pow(base, 5)) {
      digitGroups = 5;
    }

    return "${_f.format(this / pow(base, digitGroups))} ${units[digitGroups]}";
  }
}