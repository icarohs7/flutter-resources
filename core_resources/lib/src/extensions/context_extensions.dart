import 'package:flutter/material.dart';

extension CRContextExtensions on BuildContext {
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(SnackBar snackBar) {
    return scaffoldMessenger.showSnackBar(snackBar);
  }
}
