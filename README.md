# Flutter Resources

A collection of small, reusable Flutter and Dart packages for common UI,
state, stream, functional-programming, and application-infrastructure needs.

[![Actions Status](https://github.com/icarohs7/flutter-resources/workflows/build/badge.svg)](https://github.com/icarohs7/flutter-resources/actions)
[![GitHub license](https://img.shields.io/github/license/icarohs7/flutter-resources.svg)](https://github.com/icarohs7/flutter-resources/blob/master/LICENSE)
[![codecov](https://codecov.io/gh/icarohs7/flutter-resources/branch/master/graph/badge.svg)](https://codecov.io/gh/icarohs7/flutter-resources)

This repository contains independent packages. Add only the package your app
needs when you want a smaller dependency surface. [`flutter-resources2`](https://github.com/icarohs7/flutter-resources2)
is the broader, app-oriented package built on top of several packages here.

## Requirements

- Dart `>=3.13.0 <4.0.0`
- Flutter `3.47.0` (the version used by CI)
- Packages are currently consumed from Git and are not published to pub.dev.

## Packages

| Package | Use it for | Representative APIs |
| --- | --- | --- |
| [`core_resources`](core_resources/) | Shared Flutter extensions, hooks, navigation helpers, validation, and widgets | `LoadingElevatedButton`, `EditableLabel`, `Core`, `BuildContext` extensions |
| [`masked_text_resources`](masked_text_resources/) | Text-input masks | `FieldMasks`, `MaskTextInputFormatter` |
| [`search_resources`](search_resources/) | Search app bars and delegates | `SearchAppBar`, `SimpleSearchDelegate` |
| [`stream_resources`](stream_resources/) | RxDart helpers and Flutter hooks | `useValueStream`, `subject` |
| [`reactor_fp_resources`](reactor_fp_resources/) | `ValueNotifier` state and functional programming | `Reactor`, `StreamReactor`, `Either`, `Task`, `TaskEither` |
| [`value_notifier_resources`](value_notifier_resources/) | Derived and filtered `ValueListenable`s | `computedValueListenable`, `mapEvent`, `whereEvent` |

The internal dependency relationships are intentionally simple:

```text
core_resources
├── masked_text_resources
├── search_resources
├── stream_resources
└── value_notifier_resources
    └── reactor_fp_resources
```

## Installation

Install a package from Git by replacing `<package>` with one of the package
names above:

```sh
flutter pub add <package> --git-url=https://github.com/icarohs7/flutter-resources --git-path=<package>
```

For example:

```sh
flutter pub add core_resources --git-url=https://github.com/icarohs7/flutter-resources --git-path=core_resources
```

For local development, use a path dependency instead:

```yaml
dependencies:
  core_resources:
    path: ../flutter-resources/core_resources
```

Import the package's public library file rather than files under `lib/src`:

```dart
import 'package:core_resources/core_resources.dart';
```

## Quick examples

### Loading button

```dart
import 'package:core_resources/core_resources.dart';

LoadingElevatedButton(
  onPressed: isSaving ? null : save,
  isLoading: isSaving,
  child: const Text('Save'),
)
```

### Reactor state

```dart
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

final counter = Reactor(0);

counter.reduce((value) => value + 1);
print(counter.value); // 1
```

### Computed `ValueListenable`

```dart
import 'package:flutter/foundation.dart';
import 'package:value_notifier_resources/value_notifier_resources.dart';

final firstName = ValueNotifier('Ada');
final lastName = ValueNotifier('Lovelace');

final fullName = computedValueListenable((ref) {
  return '${ref.watch(firstName)} ${ref.watch(lastName)}';
});
```

## Development

From the repository root, run the CI-equivalent check for every package:

```sh
dart run build.dart
```

This fetches dependencies, analyzes each package, and runs its tests with
coverage. To work on one package only:

```sh
cd core_resources
flutter pub get
flutter analyze
flutter test --coverage
```

Each package exposes its supported API through its top-level file, such as
[`core_resources.dart`](core_resources/lib/core_resources.dart) or
[`reactor_fp_resources.dart`](reactor_fp_resources/lib/reactor_fp_resources.dart).

## Licensing and attribution

The repository is distributed under the license in [`LICENSE`](LICENSE).
`reactor_fp_resources` contains functional-programming code adapted from
[`fpdart`](https://pub.dev/packages/fpdart); see its separate
[`LICENSE`](reactor_fp_resources/LICENSE) file for attribution.
