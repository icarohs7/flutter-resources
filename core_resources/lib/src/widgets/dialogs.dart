import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../core_resources.dart';

Future<T?> showSimpleAlert<T>(
  BuildContext context, {
  Widget? title,
  Widget? content,
  String? confirmText,
  Function(BuildContext context)? onConfirm,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) =>
        SimpleAlert(title: title, content: content, confirmText: confirmText, onConfirm: onConfirm),
  );
}

Future<T?> showSimpleTimedAlert<T>(
  BuildContext context, {
  Duration? duration,
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
      duration: duration ?? Duration(seconds: 2),
    ),
  );
}

class const SimpleTimedAlert({
  super.key,
  final Widget? title,
  final Widget? content,
  final Function(BuildContext context)? onConfirm,
  final String? confirmText,
  required final Duration duration,
  final Widget? Function(double animationValue)? progressIndicatorBuilder,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: duration);
    useStartAnimationControllerWithCompletionCallback(
      animationController,
      Navigator.of(context).maybePop,
    );

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      clipBehavior: .antiAlias,
      title: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
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

class const SimpleAlert({
  super.key,
  final Widget? title,
  final Widget? content,
  final Function(BuildContext context)? onConfirm,
  final String? confirmText,
}) extends StatelessWidget {
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

class const ConfirmDialog({
  final Widget? title,
  final Widget? content,
  final FutureOr<void> Function(BuildContext context)? onConfirm,
  final FutureOr<void> Function(BuildContext context)? onCancel,
  final String? cancelText,
  final String? confirmText,
  super.key,
}) extends StatelessWidget {
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
