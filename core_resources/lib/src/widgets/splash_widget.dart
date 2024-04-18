// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns a widget wrapping the [child] and running
/// the given [operation] once
class SplashWidget extends HookWidget {
  const SplashWidget({
    super.key,
    required this.child,
    required this.operation,
  });

  final Widget child;
  final FutureOr<void> Function(BuildContext context) operation;

  @override
  Widget build(BuildContext context) {
    final operation = useMemoized(() => this.operation);

    useEffect(() {
      Future(() async {
        if (!context.mounted) return;
        await operation(context);
      });
      return null;
    }, []);

    return child;
  }
}
