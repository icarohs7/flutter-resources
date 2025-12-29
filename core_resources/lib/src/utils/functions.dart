/// Invoke the given [function]
T invoke<T>(T Function() function) => function();

/// Converts any object to its string representation
String identityString(Object? object) => '$object';
