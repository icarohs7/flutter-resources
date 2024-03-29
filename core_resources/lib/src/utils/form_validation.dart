import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

import '../extensions/number_extensions.dart';

/// Use multiple validators, returning null if all of them pass or the result of the
/// first one not passing
FormFieldValidator<String> validators(List<FormFieldValidator<String>> validators) {
  return (input) {
    return validators.firstWhere(
      (validator) => (validator(input) ?? '').isNotBlank,
      orElse: () => (s) => null,
    )(input);
  };
}

/// Validator only allowing non-blank values
FormFieldValidator<String> requiredValidator({String errorMessage = 'Campo obrigatório'}) {
  return (input) => (input ?? '').isBlank ? errorMessage : null;
}

/// Validator only allowing values above the given length
FormFieldValidator<String> minLengthValidator(int minLength, {String? errorMessage}) {
  return (input) {
    return (input ?? '').length < minLength
        ? (errorMessage ?? 'Mínimo de $minLength caracteres requiridos')
        : null;
  };
}

/// Validator only allowing valid emails
FormFieldValidator<String> emailValidator({
  String errorMessage = 'Email inválido',
  bool allowBlank = false,
}) {
  final emailRegex = RegExp(r'''^[^@]+@[^@]+$''');
  return (input) {
    final str = input ?? '';
    if (allowBlank && str.isBlank) return null;
    return emailRegex.hasMatch(str) ? null : errorMessage;
  };
}

/// Validator only allowing valid phone numbers
FormFieldValidator<String> phoneValidator({
  int requiredLength = 11,
  String errorMessage = 'Telefone inválido',
}) {
  return (input) => (input ?? '').onlyNumbers().length == requiredLength ? null : errorMessage;
}

/// Validator only allowing valid cpf numbers
FormFieldValidator<String> cpfValidator({String errorMessage = 'CPF inválido'}) {
  return (input) => (input ?? '').onlyNumbers().length == 11 ? null : errorMessage;
}

/// Validator only allowing valid cnpj numbers
FormFieldValidator<String> cnpjValidator({String errorMessage = 'CNPJ inválido'}) {
  return (input) => (input ?? '').onlyNumbers().length == 14 ? null : errorMessage;
}

/// Validator only allowing valid zip numbers
FormFieldValidator<String> zipValidator({String errorMessage = 'CEP inválido'}) {
  return (input) => (input ?? '').onlyNumbers().length == 8 ? null : errorMessage;
}

/// Validator only allowing valid zip numbers
FormFieldValidator<String> userValidator({String errorMessage = 'Nome de usuário inválido'}) {
  return (input) {
    final regex = RegExp(r'^[a-zA-Z._][a-zA-Z._\d]*$');
    return regex.hasMatch(input ?? '') ? null : errorMessage;
  };
}

/// Validator only allowing values that can convert to integer
FormFieldValidator<String> validIntValidator({String errorMessage = 'Número inválido'}) {
  return (input) {
    return (input ?? '').toIntOrNull() != null ? null : errorMessage;
  };
}

/// Validator only allowing values that can convert to double
FormFieldValidator<String> validDoubleValidator({String errorMessage = 'Número inválido'}) {
  return (input) {
    return (input ?? '').toDoubleOrNull() != null ? null : errorMessage;
  };
}
