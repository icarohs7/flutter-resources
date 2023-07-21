import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EditableLabel extends HookWidget {
  // ignore: use_key_in_widget_constructors
  const EditableLabel({
    Key? key,
    this.onSave,
    this.controller,
    this.labelText,
    this.inputFormatters,
    this.validator,
    this.keyboardType,
    this.initialValue,
    this.editable,
    this.filled,
    this.fillColor,
    this.labelStyle,
    this.animationDuration = const Duration(milliseconds: 250),
    this.enabled,
    this.border,
  }) : inputKey = key;

  final Key? inputKey;
  final FutureOr<bool> Function()? onSave;
  final TextEditingController? controller;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String? initialValue;
  final bool? editable;
  final bool? filled;
  final Color? fillColor;
  final TextStyle? labelStyle;
  final Duration animationDuration;
  final bool? enabled;
  final InputBorder? border;

  @override
  Widget build(BuildContext context) {
    final editing = useState(false);

    return Row(
      children: <Widget>[
        Expanded(
          child: AnimatedPadding(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: editing.value ? 8 : 2,
            ),
            child: IgnorePointer(
              ignoring: !editing.value,
              child: TextFormField(
                initialValue: initialValue,
                key: inputKey,
                inputFormatters: inputFormatters,
                controller: controller,
                validator: validator,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: border ??
                      (editing.value ? null : OutlineInputBorder(borderSide: BorderSide.none)),
                  filled: filled,
                  fillColor: fillColor,
                  labelStyle: labelStyle,
                ),
                enabled: enabled ?? editing.value,
              ),
            ),
          ),
        ),
        if (editable ?? true)
          IconButton(
            icon: AnimatedSwitcher(
              switchInCurve: Curves.decelerate,
              switchOutCurve: Curves.easeInExpo,
              duration: animationDuration,
              child: editing.value
                  ? Icon(Icons.save, key: ValueKey(1))
                  : Icon(Icons.edit, key: ValueKey(2)),
              transitionBuilder: (child, value) {
                return ScaleTransition(scale: value, child: child);
              },
            ),
            onPressed: () async {
              final allowSwitch = (editing.value && onSave != null) ? await onSave!() : true;
              if (allowSwitch) {
                editing.value = !editing.value;
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
          ),
      ],
    );
  }
}
