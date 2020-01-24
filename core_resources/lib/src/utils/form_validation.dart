import 'package:core_resources/core_resources.dart';
import 'package:flutter/cupertino.dart';

///Use multiple validators, returning null if all of them pass or the result of the
///first one not passing
FormFieldValidator<String> validators(List<FormFieldValidator<String>> validators) {
  return (input) {
    return validators.firstWhere(
      (validator) => (validator(input) ?? '').isNotBlank,
      orElse: () => (s) => null,
    )(input);
  };
}

///Validator only allowing non-blank values
FormFieldValidator<String> requiredValidator({String errorMessage}) {
  return (input) => (input ?? '').isBlank ? (errorMessage ?? 'Campo obrigatório') : null;
}

///Validator only allowing values above the given length
FormFieldValidator<String> minLengthValidator(int minLength, {String errorMessage}) {
  return (input) {
    return (input ?? '').length < minLength
        ? (errorMessage ?? 'Mínimo de $minLength caracteres requiridos')
        : null;
  };
}

///Validator only allowing valid emails
FormFieldValidator<String> emailValidator({String errorMessage}) {
  final emailRegex = RegExp(
      r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''');
  return (input) => emailRegex.hasMatch(input) ? (errorMessage ?? 'Email inválido') : null;
}
