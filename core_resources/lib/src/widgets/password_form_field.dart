import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class const PasswordFormField({
  super.key,
  final Key? fieldKey,
  final TextEditingController? controller,
  final Widget? prefixIcon,
  final int? maxLength,
  final String? hintText,
  final String? labelText,
  final String? helperText,
  final bool? enabled,
  final FormFieldSetter<String>? onSaved,
  final FormFieldValidator<String>? validator,
  final ValueChanged<String>? onFieldSubmitted,
  final String obscuringCharacter = '•',
  final Color? fillColor,
  final TextInputAction? textInputAction,
}) extends HookWidget {
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
      decoration: .new(
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
