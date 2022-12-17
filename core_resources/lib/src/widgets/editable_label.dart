import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditableLabel extends StatefulWidget {
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

  @override
  // ignore: library_private_types_in_public_api
  _EditableLabelState createState() => _EditableLabelState();
}

class _EditableLabelState extends State<EditableLabel> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: AnimatedPadding(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: _editing ? 8 : 2,
            ),
            child: TextFormField(
              initialValue: widget.initialValue,
              key: widget.inputKey,
              inputFormatters: widget.inputFormatters,
              controller: widget.controller,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                labelText: widget.labelText,
                border: _editing ? null : OutlineInputBorder(borderSide: BorderSide.none),
                filled: widget.filled,
                fillColor: widget.fillColor,
                labelStyle: widget.labelStyle,
              ),
              enabled: _editing,
            ),
          ),
        ),
        if (widget.editable ?? true)
          IconButton(
            icon: AnimatedSwitcher(
              switchInCurve: Curves.decelerate,
              switchOutCurve: Curves.easeInExpo,
              duration: Duration(milliseconds: 250),
              child: _editing
                  ? Icon(Icons.save, key: ValueKey(1))
                  : Icon(Icons.edit, key: ValueKey(2)),
              transitionBuilder: (child, value) {
                return ScaleTransition(scale: value, child: child);
              },
            ),
            onPressed: () async {
              final allowSwitch =
                  await (_editing && (widget.onSave != null) ? widget.onSave!() : true);
              if (allowSwitch) {
                setState(() => _editing = !_editing);
              }
            },
          ),
      ],
    );
  }
}
