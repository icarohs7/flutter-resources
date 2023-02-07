// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SplashWidget<T> extends HookWidget {
  const SplashWidget({
    super.key,
    required this.future,
    required this.child,
    required this.onComplete,
  });

  final Future<T> future;
  final Widget child;
  final FutureOr<void> Function(BuildContext context, T value) onComplete;

  @override
  Widget build(BuildContext context) {
    final future = useMemoized(() => this.future);
    final onComplete = useMemoized(() => this.onComplete);
    final isMounted = useIsMounted();

    useEffect(() {
      Future(() async {
        if (!isMounted()) return;
        final result = await future;
        if (!isMounted()) return;
        await onComplete(context, result);
      });
      return null;
    }, []);

    return child;
  }
}
