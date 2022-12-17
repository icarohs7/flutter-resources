import 'package:flutter/material.dart';

import '../../core_resources.dart';

class FutureLoadingRaisedButton extends StatefulWidget {
  const FutureLoadingRaisedButton({
    super.key,
    required this.onPressed,
    this.child,
  });

  final Widget? child;
  final Future<void> Function() onPressed;

  @override
  // ignore: library_private_types_in_public_api
  _FutureLoadingRaisedButtonState createState() => _FutureLoadingRaisedButtonState();
}

class _FutureLoadingRaisedButtonState extends State<FutureLoadingRaisedButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingRaisedButton(
      isLoading: _isLoading,
      onPressed: _isLoading
          ? null
          : () async {
              try {
                setState(() => _isLoading = true);
                await widget.onPressed();
              } finally {
                setState(() => _isLoading = false);
              }
            },
      child: widget.child,
    );
  }
}
