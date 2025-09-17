import 'dart:convert';
import 'dart:typed_data';

import 'package:toxic/util/charcodec.dart';

extension XDataIntList on Uint8List {
  String get hex {
    StringBuffer sb = StringBuffer();
    for (int byte in this) {
      sb.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return sb.toString();
  }

  String get base64 => base64Encode(this);

  String get base64Url => base64UrlEncode(this);

  String encodeWithCharset(String charset) =>
      "$charset${CharCodec.encodeBase64WithCharset(base64Input: base64, charset: charset)}";

  String encodeBundleCharset(String charset) =>
      CharCodec.encodeCompressedBundle(charset: charset, base64Input: base64);

  String get utf8 => String.fromCharCodes(this);
}
