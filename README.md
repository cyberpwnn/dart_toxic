# 🚀 TOXIC: Supercharge Your Dart Types 🚀

## 🌟 Project Synopsis

**TOXIC** is a cutting-edge Dart/Flutter initiative that supercharges 🛠️ Dart's foundational data types like `Int`, `Double`, and `String`. It introduces a rich collection of extensions designed to elevate your coding workflow, inject advanced features, and refine the developer's journey.

## ✨ Enhanced Feature Set

### 🧬 TInt Extensions

`TInt` breathes new life into integers, adding:

- `to`: 🔗 Seamlessly interpolate between integers.
- `plural`: 📏 Auto-select singular or plural forms based on value.
- `format`: 🌍 Locale-aware formatting.
- `formatCompact`: 📉 Streamlined integer representation.

### 📝 TString Extensions

`TString` evolves strings by adding transformative powers:

- `roadkill`, `upperRoadkill`, `dashkill`, `upperDashkill`: 🔄 Swap spaces with underscores/dashes, with case options.
- `camelCase`: 🐫 Convert strings to camel case.
- `randomCase`: 🎲 Jumble up the case for a fun twist.
- `reversed`: ↩️ Flip the script, literally.
- `Split functions`: 🔪 Easily divide strings by various delimiters.
- `Capitalization functions`: 🔠 Capitalize single words or entire sentences.

### 🔢 TDouble Extensions

`TDouble` refines doubles with:

- `percent`: 💯 Transform to percentage with precision.
- `format`: 🎨 Apply locale-specific formatting.
- `formatCompact`: 🗜️ Compress the double for brevity.
- `to`: 🔗 Interpolate between doubles with ease.

### ⏳ TFuture Extensions

`TFuture` adds afterburners to `Future<T>`:

- `thenRun`: 🏃‍♂️ Execute functions post-completion.

### 🗺️ TMap Extensions

`TMap` opens up new pathways for maps:

- Overloaded operators: 🔑 Merge keys (`+`).
- Overloaded operators: 🔑 Remove keys (`-`).
- Sorting functions: 🔢 Sort by keys or values.
- Compute functions: 💻 Calculate values, sync or async.
- Flipping functions: 🔄 Reverse key-value pairs.
- Merge function: 🤝 Unite two maps into one.

### 📊 TIterableInt Extensions

`TIterableInt` delivers arithmetic and stats for integer series:

- Arithmetic operators: ➕➖✖️➗ and more for batch operations.
- Statistical methods: 📈 Compute sum, product, min, max, average, median, mode.

### 🔟 TIterableDouble Extensions

`TIterableDouble` mirrors `TIterableInt`, but for doubles:

- Arithmetic operators: Same as `TIterableInt`.
- Statistical methods: As robust as `TIterableInt`.

### 📃 TList Extensions

`TList` enhances lists with elemental tactics:

- Overloaded operators: ➕ Add and ➖ Subtract elements.

### ✅ TSet Extensions

`TSet` streamlines set manipulation:

- Overloaded operators: ➕ Add and ➖ Remove elements.

### 🔄 TIterable Extensions

`TIterable` is a swiss-army knife for iterables:

- Addition methods: 🔝 Add elements at any end.
- Statistical and utility functions: 🧮 Count, dedupe, shuffle.
- Accessors: 🔍 Find indices or middle values.
- Sorting and mapping functions: 🔄 Sort and map effortlessly.

## 🚀 Usage Pro-Tips

Dive into TOXIC's extensions with these precise Dart code snippets:

### 🧮 TInt Example:

```dart
int count = 2;
print(count.to(10, 0.5)); // 👉 6.0
print(count.plural("apple", "apples")); // 👉 "apples"
print(count.format()); // 👉 "2" in most locales
print(count.formatCompact()); // 👉 "2"
```

### ✍ TString Example:

```dart
String text = "Hello World";
print(text.roadkill); // 👉 "hello_world"
print(text.upperRoadkill); // 👉 "HELLO_WORLD"
print(text.camelCase); // 👉 "helloWorld"
print(text.reversed); // 👉 "dlroW olleH"
print(text.capitalizeWords()); // 👉 "Hello World"
```

### 🔢 TDouble Example:

```dart
double value = 0.123;
print(value.percent(2)); // 👉 "12.30%"
print(value.format()); // 👉 Locale-dependent, e.g., "0.123"
print(value.formatCompact()); // 👉 e.g., "123"
print(value.to(1.0, 0.5)); // 👉 0.5615
```

### ⌛ TFuture Example:

```dart
Future<int> futureValue = Future.value(5);
futureValue.thenRun((value) => print("Value: $value")); 
// After future completes, 👉 "Value: 5"
```

### 🗺️ TMap Example:

```dart
Map<String, int> map1 = {'a': 1, 'b': 2};
Map<String, int> map2 = {'c': 3};
Map<String, int> combined = map1 + map2;
print(combined); // 👉 {'a': 1, 'b': 2, 'c': 3}
Map<String, int> reduced = combined - 'b';
print(reduced); // 👉 {'a': 1, 'c': 3}
```

### 📊 TIterableInt Example:

```dart
Iterable<int> numbers = [1, 2, 3, 4];
print(numbers * 2); // 👉 [2, 4, 6, 8]
print(numbers.sum()); // 👉 10
print(numbers.average()); // 👉 2.5
```

### 🔟 TIterableDouble Example:

```dart
Iterable<double> doubles = [1.5, 2.5, 3.5];
print(doubles + 1); // 👉 [2.5, 3.5, 4.5]
print(doubles.sum()); // 👉 7.5
print(doubles.average()); // 👉 2.5
```

### 📃 TList Example:

```dart
List<int> list = [1, 2, 3];
List<int> extended = list + 4;
print(extended); // 👉 [1, 2, 3, 4]
List<int> reduced = extended - 2;
print(reduced); // 👉 [1, 3, 4]
```

### ✅ TSet Example:

```dart
Set<int> set = {1, 2, 3};
Set<int> extended = set + 4;
print(extended); // 👉 {1, 2, 3, 4}
Set<int> reduced = extended - 2;
print(reduced); // 👉 {1, 3, 4}
```

### 🔄 TIterable Example:

```dart
Iterable<int> numbers = [1, 2, 2, 3];
Iterable<int> uniqueNumbers = numbers.deduplicated();
print(uniqueNumbers.toList()); // 👉 [1, 2, 3]
Iterable<int> shuffledNumbers = numbers.shuffled();
print(shuffledNumbers.toList()); // Random order each time
Map<int, int> occurrences = numbers.occurrences();
print(occurrences); // 👉 {1: 1, 2: 2, 3: 1}
```

Elevate your Dart applications to the next level with TOXIC's extensions—write less code while boosting readability and maintainability.