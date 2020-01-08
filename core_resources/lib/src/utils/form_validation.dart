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
