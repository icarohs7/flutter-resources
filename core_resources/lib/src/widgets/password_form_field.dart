import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordFormField extends HookWidget {
  const PasswordFormField({
    super.key,
    this.fieldKey,
    this.controller,
    this.prefixIcon,
    this.maxLength,
    this.hintText,
    this.labelText,
    this.helperText,
    this.enabled,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.obscuringCharacter = '•',
    this.fillColor,
    this.textInputAction,
  });

  final Key? fieldKey;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final int? maxLength;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final bool? enabled;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final String obscuringCharacter;
  final Color? fillColor;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(true);

    return TextFormField(
      key: fieldKey,
      controller: controller,
      obscureText: obscureText.value,
      maxLength: maxLength,
      onSaved: onSaved,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      obscuringCharacter: obscuringCharacter,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        fillColor: fillColor,
        filled: fillColor != null,
        suffixIcon: GestureDetector(
          onTap: () => obscureText.value = !obscureText.value,
          child: Icon(obscureText.value ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
