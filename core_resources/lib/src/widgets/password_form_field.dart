import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
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
  final Color? fillColor;
  final TextInputAction? textInputAction;

  @override
  // ignore: library_private_types_in_public_api
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      controller: widget.controller,
      obscureText: _obscureText,
      maxLength: widget.maxLength,
      onSaved: widget.onSaved,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        fillColor: widget.fillColor,
        filled: widget.fillColor != null,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
