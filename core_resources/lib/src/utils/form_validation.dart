import 'package:core_resources/core_resources.dart';
import 'package:flutter/cupertino.dart';

///Use multiple validators, returning null if all of them pass or the result of the
///first one not passing
FormFieldValidator<String> validators(List<FormFieldValidator<String>> validators) {
  return (input) {
    return validators.firstWhere((validator) => (validator(input) ?? "").isNotBlank)(input);
  };
}

///Validator only allowing non-blank values
FormFieldValidator<String> requiredValidator() {
  return (input) => (input ?? "").isBlank ? "Campo obrigatório" : null;
}
