// ignore_for_file: avoid_print

import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

class SplashWidget<T> extends StatelessWidget {
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
    return HookBuilder(builder: (context) {
      final future = useMemoized(() => this.future);
      final isMounted = useIsMounted();

      useEffect(() {
        if (isMounted()) {
          future.then((value) async {
            if (isMounted()) {
              await onComplete(context, value);
            }
          });
        }
        return null;
      }, [future]);

      return child;
    });
  }
}
