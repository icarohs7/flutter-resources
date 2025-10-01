import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Future<T?> showSimpleAlert<T>(
  BuildContext context, {
  Widget? title,
  Widget? content,
  String? confirmText,
  Function(BuildContext context)? onConfirm,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) => SimpleAlert(
      title: title,
      content: content,
      confirmText: confirmText,
      onConfirm: onConfirm,
    ),
  );
}

Future<T?> showSimpleTimedAlert<T>(
  BuildContext context, {
  required Duration duration,
  Widget? title,
  Widget? content,
  String? confirmText,
  Function(BuildContext context)? onConfirm,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) => SimpleTimedAlert(
      title: title,
      content: content,
      confirmText: confirmText,
      onConfirm: onConfirm,
      duration: duration,
    ),
  );
}

class SimpleTimedAlert extends HookWidget {
  final Widget? title;
  final Widget? content;
  final String? confirmText;
  final Function(BuildContext context)? onConfirm;
  final Duration duration;
  final Widget? Function(double animationValue)? progressIndicatorBuilder;

  const SimpleTimedAlert({
    super.key,
    this.title,
    this.content,
    this.onConfirm,
    this.confirmText,
    required this.duration,
    this.progressIndicatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: duration);

    useEffect(() {
      listener(AnimationStatus status) {
        if (status == AnimationStatus.completed) Navigator.of(context).maybePop();
      }

      animationController.forward();
      animationController.addStatusListener(listener);

      return () => animationController.removeStatusListener(listener);
    }, [duration]);

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) =>
                progressIndicatorBuilder?.call(animationController.value) ??
                LinearProgressIndicator(
                  value: animationController.value,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.titleLarge!,
                child: title!,
              ),
            ),
        ],
      ),
      content: content,
      actions: <Widget>[
        TextButton(
          child: Text(confirmText ?? 'Ok'),
          onPressed: () => onConfirm?.call(context) ?? Navigator.pop(context),
        ),
      ],
    );
  }
}

class SimpleAlert extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final String? confirmText;
  final Function(BuildContext context)? onConfirm;

  const SimpleAlert({
    super.key,
    this.title,
    this.content,
    this.onConfirm,
    this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        TextButton(
          child: Text(confirmText ?? 'Ok'),
          onPressed: () => onConfirm?.call(context) ?? Navigator.pop(context),
        ),
      ],
    );
  }
}

Future<bool> showConfirmDialog(
  BuildContext context, {
  Widget? title,
  Widget? content,
  FutureOr<void> Function(BuildContext context)? onConfirm,
  FutureOr<void> Function(BuildContext context)? onCancel,
  String? cancelText,
  String? confirmText,
}) async {
  return (await showDialog<bool>(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: title,
            content: content,
            onConfirm: onConfirm,
            onCancel: onCancel,
            cancelText: cancelText,
            confirmText: confirmText,
          );
        },
      )) ??
      false;
}

class ConfirmDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final FutureOr<void> Function(BuildContext context)? onConfirm;
  final FutureOr<void> Function(BuildContext context)? onCancel;
  final String? cancelText;
  final String? confirmText;

  const ConfirmDialog({
    this.title,
    this.content,
    this.onConfirm,
    this.onCancel,
    this.cancelText,
    this.confirmText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        TextButton(
          onPressed: () => onCancel?.call(context) ?? Navigator.of(context).pop(false),
          child: Text(cancelText ?? 'Cancelar'),
        ),
        TextButton(
          onPressed: () => onConfirm?.call(context) ?? Navigator.of(context).pop(true),
          child: Text(confirmText ?? 'Confirmar'),
        ),
      ],
    );
  }
}
