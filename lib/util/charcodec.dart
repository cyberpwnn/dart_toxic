import 'dart:convert';
import 'dart:math';

class CharCodec {
  const CharCodec._();

  static String encodeBundle(
          {required String base64Input, required String charset}) =>
      "$charset${encodeBase64WithCharset(base64Input: base64Input, charset: charset)}";

  static String encodeCompressedBundle(
      {required String base64Input, required String charset}) {
    String initial =
        encodeBase64WithCharset(charset: charset, base64Input: base64Input);
    String bestBundle =
        encodeBundle(base64Input: base64Input, charset: charset);

    while (true) {
      String uniqueCharset = getUniqueCharset(initial);
      String newBundle =
          encodeBundle(base64Input: base64Input, charset: uniqueCharset);
      if (newBundle.length < bestBundle.length) {
        bestBundle = newBundle;
        initial = newBundle.substring(uniqueCharset.length);
      } else {
        return bestBundle;
      }
    }
  }

  static String getUniqueCharset(String content) {
    List<String> uniqueChars = [];
    for (int i = 0; i < content.length; i++) {
      String char = content[i];
      if (!uniqueChars.contains(char)) {
        uniqueChars.add(char);
      }
    }
    return uniqueChars.join();
  }

  static String encodeBase64WithCharset(
      {required String base64Input, required String charset}) {
    if (base64Input.isEmpty) return '';
    List<int> bytes = base64.decode(base64Input);
    int n = charset.length;
    if (n < 2)
      throw Exception('Charset must have at least 2 unique characters');
    BigInt number = BigInt.zero;
    for (int byte in bytes) {
      number = (number << 8) | BigInt.from(byte & 0xFF);
    }

    int bitLength = bytes.length * 8;
    if (bitLength == 0) return '';

    double log2N = log(n) / log(2);
    int outputLength = (bitLength / log2N).ceil().toInt();

    List<int> digits = [];
    BigInt base = BigInt.from(n);

    while (number > BigInt.zero) {
      digits.add((number % base).toInt());
      number = number ~/ base;
    }

    while (digits.length < outputLength) {
      digits.add(0);
    }

    digits = digits.reversed.toList();

    StringBuffer sb = StringBuffer();
    for (int digit in digits) {
      sb.write(charset[digit]);
    }

    return sb.toString();
  }

  static String extractCharsetFromBundle(String encoded) {
    List<String> x = [];
    for (int i = 0; i < encoded.length; i++) {
      if (!x.contains(encoded[i])) {
        x.add(encoded[i]);
      } else {
        break;
      }
    }

    return x.join();
  }

  static String decodeBundle(String encoded) {
    String charset = extractCharsetFromBundle(encoded);
    return decodeFromBase64(
        encoded: encoded.substring(charset.length), charset: charset);
  }

  static String decodeFromBase64({
    required String encoded,
    required String charset,
  }) {
    if (encoded.isEmpty) return '';

    int outputLength = encoded.length;
    int n = charset.length;
    if (n < 2)
      throw Exception('Charset must have at least 2 unique characters');

    Map<String, int> charToDigit = {};
    for (int i = 0; i < n; i++) {
      String ch = charset[i];
      if (charToDigit.containsKey(ch)) {
        throw Exception('Charset must have unique characters');
      }
      charToDigit[ch] = i;
    }

    BigInt number = BigInt.zero;
    BigInt base = BigInt.from(n);
    for (int i = 0; i < outputLength; i++) {
      String ch = encoded[i];
      int? digit = charToDigit[ch];
      if (digit == null) throw Exception('Invalid character in encoded string');
      number = number * base + BigInt.from(digit);
    }

    double log2N = log(n) / log(2);
    double maxBits = outputLength * log2N;
    double minBits = (outputLength - 1) * log2N;

    int byteLen = (maxBits / 8).floor();
    int bitLen = byteLen * 8;
    if (!(bitLen > minBits && bitLen <= maxBits)) {
      throw Exception('Invalid encoded length for this charset');
    }

    List<int> bytes = List<int>.filled(byteLen, 0);
    BigInt temp = number;
    for (int i = byteLen - 1; i >= 0; i--) {
      bytes[i] = (temp & BigInt.from(0xFF)).toInt();
      temp = temp >> 8;
    }
    if (temp != BigInt.zero) {
      throw Exception('Number too large for the computed byte length');
    }

    return base64.encode(bytes);
  }
}
