import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// ignore: use_key_in_widget_constructors
class const EditableLabel({
  Key? key,
  final FutureOr<bool> Function()? onSave,
  final TextEditingController? controller,
  final String? labelText,
  final List<TextInputFormatter>? inputFormatters,
  final FormFieldValidator<String>? validator,
  final TextInputType? keyboardType,
  final String? initialValue,
  final String? value,
  final bool? editable,
  final bool? filled,
  final Color? fillColor,
  final TextStyle? labelStyle,
  final Duration animationDuration = const Duration(milliseconds: 250),
  final bool? enabled = true,
  final InputBorder? border,
}) extends HookWidget {
  this : assert(value == null || (controller == null && initialValue == null));

  final Key? inputKey = key;
  @override
  Widget build(BuildContext context) {
    final editing = useState(false);
    final ownedController = useTextEditingController(text: value);

    useEffect(() {
      final currentValue = value;
      if (currentValue != null && ownedController.text != currentValue) {
        ownedController.text = currentValue;
      }
      return null;
    }, [value]);

    final effectiveController = controller ?? (value == null ? null : ownedController);

    return Row(
      children: <Widget>[
        Expanded(
          child: AnimatedPadding(
            duration: .new(milliseconds: 250),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: editing.value ? 8 : 2),
            child: IgnorePointer(
              ignoring: !editing.value,
              child: TextFormField(
                initialValue: value == null ? initialValue : null,
                key: inputKey,
                inputFormatters: inputFormatters,
                controller: effectiveController,
                validator: validator,
                keyboardType: keyboardType,
                decoration: .new(
                  labelText: labelText,
                  border: border ?? (editing.value ? null : OutlineInputBorder(borderSide: .none)),
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
              if (!context.mounted) return;
              if (allowSwitch) {
                editing.value = !editing.value;
                FocusScope.of(context).requestFocus(.new());
              }
            },
          ),
      ],
    );
  }
}
