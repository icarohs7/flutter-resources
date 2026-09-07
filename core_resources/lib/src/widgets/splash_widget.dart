// ignore_for_file: avoid_print

import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns a widget wrapping the [child] and running
/// the given [operation] once
class const SplashWidget({
  super.key,
  required final Widget child,
  required final FutureOr<void> Function(BuildContext context) operation,
}) extends HookWidget {
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
