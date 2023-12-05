# TOXIC - The Horrible, Extension Library for Dart
___
## Project Overview
TOXIC is a Dart/Flutter project designed to augment the Dart language's core data types such as `Int`, `Double`, and `String` with a comprehensive suite of extensions. These extensions streamline common tasks, introduce new functionalities, and enhance the overall development experience.
___
## Feature Extensions
### TInt

`TInt` enriches the integer type with a variety of utility methods:

- `to`: Linear interpolation between integers.
- `plural`: Determines the correct singular or plural form based on the integer's value.
- `format`: Applies locale-specific formatting to the integer.
- `formatCompact`: Provides a shorter format representation of the integer.

### TString

`TString` expands string functionality with transformation utilities:

- `roadkill`, `upperRoadkill`, `dashkill`, `upperDashkill`: Replaces spaces with underscores or dashes, optionally adjusting case.
- `camelCase`: Transforms the string into camel case.
- `randomCase`: Randomizes the character casing within the string.
- `reversed`: Reverses the character order of the string.
- Split functions: `splitSlashes`, `splitDots`, `splitAfter`, `splitLast`.
- Capitalization functions: `capitalize`, `capitalizeWords`.

### TDouble

`TDouble` enhances the double type with formatting and interpolation:

- `percent`: Converts a double to a percentage representation.
- `format`: Formats the double according to locale-specific rules.
- `formatCompact`: Condenses the double into a more compact format.
- `to`: Performs linear interpolation between doubles.

### TFuture

`TFuture` adds post-execution capabilities to `Future<T>`:

- `thenRun`: Executes a specified function after the future's completion.

### TMap

`TMap` introduces additional methods for dynamic map handling:

- Overloaded operators: Merging (`+`) and key removal (`-`).
- Sorting functions: `sortedValuesByKey`, `sortedKeysByValue`.
- Compute functions: `compute`, `computeIfPresent`, `computeIfAbsent`, and their asynchronous variants.
- Flipping functions: `flipFlat`, `flip`.
- Merge function: Combines two maps into one.

### TIterableInt

`TIterableInt` provides arithmetic and statistical extensions for integer iterables:

- Arithmetic operators: Multiplication (`*`), division (`~/`), addition (`+`), subtraction (`-`), modulo (`%`), bitwise (`^`, `|`, `&`, `<`, `>`, `~`, `-`).
- Statistical methods: Sum, product, minimum, maximum, average (as int and double), median, mode.

### TIterableDouble

`TIterableDouble` extends double iterables with arithmetic and statistical operations:

- Arithmetic operators: Same as `TIterableInt`.
- Statistical methods: Same as `TIterableInt`.

### TList

`TList` enhances the list type with element manipulation operators:

- Overloaded operators: Element addition (`+`) and removal (`-`).

### TSet

`TSet` provides set manipulation through additional operators:

- Overloaded operators: Element addition (`+`) and removal (`-`).

### TIterable

`TIterable` adds utility and transformation methods to iterables:

- Addition methods: Add single or multiple elements at either start or end of the iterable.
- Statistical and utility functions: Count occurrences, deduplicate, shuffle.
- Accessors: Retrieve last index, middle index, middle value.
- Sorting and mapping functions: Sort, convert to keys/values, map to list with or without soft mapping.
___
## Usage Examples
Here are some specific examples demonstrating how to use TOXIC's extensions in your Dart code:

### TInt Example:

```dart
int count = 2;
print(count.to(10, 0.5)); // Outputs: 6.0
print(count.plural("apple", "apples")); // Outputs: "apples"
print(count.format()); // Outputs "2" in most locales
print(count.formatCompact()); // Outputs "2"
```

### TString Example:

```dart
String text = "Hello World";
print(text.roadkill); // Outputs: "hello_world"
print(text.upperRoadkill); // Outputs: "HELLO_WORLD"
print(text.camelCase); // Outputs: "helloWorld"
print(text.reversed); // Outputs: "dlroW olleH"
print(text.capitalizeWords()); // Outputs: "Hello World"
```

### TDouble Example:

```dart
double value = 0.123;
print(value.percent(2)); // Outputs: "12.30%"
print(value.format()); // Locale-dependent output, e.g., "0.123"
print(value.formatCompact()); // Outputs e.g., "123"
print(value.to(1.0, 0.5)); // Outputs 0.5615
```

### TFuture Example:

```dart
Future<int> futureValue = Future.value(5);
futureValue.thenRun((value) => print("Value: $value"));
// After future completes, outputs: "Value: 5"
```

### TMap Example:

```dart
Map<String, int> map1 = {'a': 1, 'b': 2};
Map<String, int> map2 = {'c': 3};
Map<String, int> combined = map1 + map2;
print(combined); // Outputs: {'a': 1, 'b': 2, 'c': 3}
Map<String, int> reduced = combined - 'b';
print(reduced); // Outputs: {'a': 1, 'c': 3}
```

### TIterableInt Example:

```dart
Iterable<int> numbers = [1, 2, 3, 4];
print(numbers * 2); // Outputs: [2, 4, 6, 8]
print(numbers.sum()); // Outputs: 10
print(numbers.average()); // Outputs: 2.5
```

### TIterableDouble Example:

```dart
Iterable<double> doubles = [1.5, 2.5, 3.5];
print(doubles + 1); // Outputs: [2.5, 3.5, 4.5]
print(doubles.sum()); // Outputs: 7.5
print(doubles.average()); // Outputs: 2.5
```

### TList Example:

```dart
List<int> list = [1, 2, 3];
List<int> extended = list + 4;
print(extended); // Outputs: [1, 2, 3, 4]
List<int> reduced = extended - 2;
print(reduced); // Outputs: [1, 3, 4]
```

### TSet Example:

```dart
Set<int> set = {1, 2, 3};
Set<int> extended = set + 4;
print(extended); // Outputs: {1, 2, 3, 4}
Set<int> reduced = extended - 2;
print(reduced); // Outputs: {1, 3, 4}
```

### TIterable Example:

```dart
Iterable<int> numbers = [1, 2, 2, 3];
Iterable<int> uniqueNumbers = numbers.deduplicated();
print(uniqueNumbers.toList()); // Outputs: [1, 2, 3]
Iterable<int> shuffledNumbers = numbers.shuffled();
print(shuffledNumbers.toList()); // Random order each time
Map<int, int> occurrences = numbers.occurrences();
print(occurrences); // Outputs: {1: 1, 2: 2, 3: 1}
```
___
By integrating TOXIC's extensions into your Dart applications, you can achieve more with less code and enhance readability and maintainability.