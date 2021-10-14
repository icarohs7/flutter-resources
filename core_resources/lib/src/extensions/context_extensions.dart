import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension CRContextExtensions on BuildContext {
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(SnackBar snackBar) {
    return scaffoldMessenger.showSnackBar(snackBar);
  }
}
