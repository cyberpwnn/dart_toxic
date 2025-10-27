/// Matches any characters that could prevent a group from capturing.
final _groupRegExp = RegExp(r'[:=!]');

/// Escapes a single character [match].
String _escape(Match match) => '\\${match[0]}';

/// Escapes a [group] to ensure it remains a capturing group.
///
/// This prevents turning the group into a non-capturing group `(?:...)`, a
/// lookahead `(?=...)`, or a negative lookahead `(?!...)`. Allowing these
/// patterns would break the assumption used to map parameter names to match
/// groups.
String rescapeGroup(String group) =>
    group.replaceFirstMapped(_groupRegExp, _escape);

/// Extracts arguments from [match] and maps them by parameter name.
///
/// The [parameters] should originate from the same path specification used to
/// create the [RegExp] that produced the [match].
Map<String, String> rextract(List<String> parameters, Match match) {
  final length = parameters.length;
  return {
    // Offset the group index by one since the first group is the entire match.
    for (var i = 0; i < length; ++i) parameters[i]: match.group(i + 1)!
  };
}

/// Generates a path by populating a path specification with [args].
///
/// The [args] should map parameter name to value.
///
/// Throws an [ArgumentError] if any required arguments are missing, or if any
/// arguments don't match their parameter's regular expression.
typedef RPathFunction = String Function(Map<String, String> args);

/// Creates a [RPathFunction] from a [path] specification.
RPathFunction pathToFunction(String path) => tokensToFunction(rparse(path));

/// Creates a [RPathFunction] from [tokens].
RPathFunction tokensToFunction(List<RToken> tokens) {
  return (args) {
    final buffer = StringBuffer();
    for (final token in tokens) {
      buffer.write(token.toPath(args));
    }
    return buffer.toString();
  };
}

/// The default pattern used for matching parameters.
const _defaultPattern = '([^/]+?)';

/// The regular expression used to extract parameters from a path specification.
///
/// Capture groups:
///   1. The parameter name.
///   2. An optional pattern.
final _parameterRegExp = RegExp(/* (1) */ r':(\w+)'
/* (2) */ r'(\((?:\\.|[^\\()])+\))?');

/// Parses a [path] specification.
///
/// Parameter names are added, in order, to [parameters] if provided.
List<RToken> rparse(String path, {List<String>? parameters}) {
  final matches = _parameterRegExp.allMatches(path);
  final tokens = <RToken>[];
  var start = 0;
  for (final match in matches) {
    if (match.start > start) {
      tokens.add(RPathToken(path.substring(start, match.start)));
    }
    final name = match[1]!;
    final optionalPattern = match[2];
    final pattern = optionalPattern != null
        ? rescapeGroup(optionalPattern)
        : _defaultPattern;
    tokens.add(RParameterToken(name, pattern: pattern));
    parameters?.add(name);
    start = match.end;
  }
  if (start < path.length) {
    tokens.add(RPathToken(path.substring(start)));
  }
  return tokens;
}

/// Creates a [RegExp] that matches a [path] specification.
///
/// See [rparse] for details about the optional [parameters] parameter.
///
/// See [tokensToRegExp] for details about the optional [prefix] and
/// [caseSensitive] parameters and the return value.
RegExp pathToRegExp(
  String path, {
  List<String>? parameters,
  bool prefix = false,
  bool caseSensitive = true,
}) =>
    tokensToRegExp(
      rparse(path, parameters: parameters),
      prefix: prefix,
      caseSensitive: caseSensitive,
    );

/// Creates a [RegExp] from [tokens].
///
/// If [prefix] is true, the returned regular expression matches the beginning
/// of input until a delimiter or end of input. Otherwise it matches the entire
/// input.
///
/// The returned regular expression respects [caseSensitive], which is true by
/// default.
RegExp tokensToRegExp(
  List<RToken> tokens, {
  bool prefix = false,
  bool caseSensitive = true,
}) {
  final buffer = StringBuffer('^');
  String? lastPattern;
  for (final token in tokens) {
    lastPattern = token.toPattern();
    buffer.write(lastPattern);
  }
  if (!prefix) {
    buffer.write(r'$');
  } else if (lastPattern != null && !lastPattern.endsWith('/')) {
    // Match until a delimiter or end of input, unless
    //  (a) there are no tokens (matching the empty string), or
    //  (b) the last token itself ends in a delimiter
    // in which case, anything may follow.
    buffer.write(r'(?=/|$)');
  }
  return RegExp(buffer.toString(), caseSensitive: caseSensitive);
}

/// The base type of all tokens produced by a path specification.
abstract class RToken {
  /// Returns the path representation of this given [args].
  String toPath(Map<String, String> args);

  /// Returns the regular expression pattern this matches.
  String toPattern();
}

/// Corresponds to a parameter of a path specification.
class RParameterToken implements RToken {
  /// Creates a parameter token for [name].
  RParameterToken(this.name, {this.pattern = r'([^/]+?)'});

  /// The parameter name.
  final String name;

  /// The regular expression pattern this matches.
  final String pattern;

  /// The regular expression compiled from [pattern].
  late final regExp = RegExp('^$pattern\$');

  @override
  String toPath(Map<String, String> args) {
    final value = args[name];
    if (value != null) {
      if (!regExp.hasMatch(value)) {
        throw ArgumentError.value('$args', 'args',
            'Expected "$name" to match "$pattern", but got "$value"');
      }
      return value;
    } else {
      throw ArgumentError.value('$args', 'args', 'Expected key "$name"');
    }
  }

  @override
  String toPattern() => pattern;
}

/// Corresponds to a non-parameterized section of a path specification.
class RPathToken implements RToken {
  /// Creates a path token with [value].
  RPathToken(this.value);

  /// A substring of the path specification.
  final String value;

  @override
  String toPath(_) => value;

  @override
  String toPattern() => RegExp.escape(value);
}
