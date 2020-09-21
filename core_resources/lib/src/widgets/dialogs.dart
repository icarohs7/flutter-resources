import 'dart:async';

import 'package:flutter/material.dart';

Future<T> showSimpleAlert<T>(
  BuildContext context, {
  Widget title,
  Widget content,
  String confirmText,
  Function() onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (context) => SimpleAlert(
      title: title,
      content: content,
      confirmText: confirmText,
      onConfirm: onConfirm,
    ),
  );
}

class SimpleAlert extends StatelessWidget {
  final Widget title;
  final Widget content;
  final String confirmText;
  final Function() onConfirm;

  const SimpleAlert({
    Key key,
    this.title,
    this.content,
    this.onConfirm,
    this.confirmText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        FlatButton(
          child: Text(confirmText ?? 'Ok'),
          onPressed: () => onConfirm != null ? onConfirm() : Navigator.pop(context),
        ),
      ],
    );
  }
}

Future<T> showConfirmDialog<T>(
  BuildContext context, {
  Widget title,
  Widget content,
  FutureOr<void> Function() onConfirm,
  FutureOr<void> Function() onCancel,
  String cancelText,
  String confirmText,
}) {
  return showDialog(
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
  );
}

class ConfirmDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final FutureOr<void> Function() onConfirm;
  final FutureOr<void> Function() onCancel;
  final String cancelText;
  final String confirmText;

  const ConfirmDialog({
    this.title,
    this.content,
    this.onConfirm,
    this.onCancel,
    this.cancelText,
    this.confirmText,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        FlatButton(
          child: Text(cancelText ?? 'Cancelar'),
          textColor: Theme.of(context).primaryColor,
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
        ),
        FlatButton(
          child: Text(confirmText ?? 'Confirmar'),
          textColor: Theme.of(context).primaryColor,
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
        )
      ],
    );
  }
}
