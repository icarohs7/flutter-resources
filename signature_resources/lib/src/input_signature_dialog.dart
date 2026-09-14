import 'dart:async';
import 'dart:typed_data';

import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signature/signature.dart';

/// A full-screen signature capture form with application-owned actions.
///
/// The host supplies navigation, labels, and optional orientation handling so
/// this widget does not depend on a router, localization, or device policy.
class const InputSignatureDialog({
  /// Called with the rendered signature, or `null` when the canvas is empty.
  required final FutureOr<void> Function(Uint8List? signature) onSubmit,

  /// Called when the user cancels signature capture.
  required final VoidCallback onCancel,

  /// Title shown in the app bar.
  required final String title,

  /// Label shown on the button that clears the canvas.
  required final String clearLabel,

  /// Label shown on the cancel button.
  required final String cancelLabel,

  /// Label shown on the submit button.
  required final String confirmLabel,

  /// Called when the dialog is shown, before the first signature is captured.
  final VoidCallback? onLockOrientationToLandscape,

  /// Called when the dialog is removed from the tree.
  final VoidCallback? onLockOrientationToPortrait,
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(SignatureController.new);

    useEffect(() => controller.dispose, [controller]);
    useEffect(() {
      onLockOrientationToLandscape?.call();
      return () => onLockOrientationToPortrait?.call();
    }, const []);

    Future<void> submitSignature() async {
      await onSubmit(await controller.toPngBytes());
    }

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: InputDecorator(
                decoration: .new(
                  // The concrete border is required because the parameter type is the abstract InputBorder.
                  // ignore: prefer-dot-shorthands
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .stretch,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 600,
                        child: Signature(controller: controller, backgroundColor: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
                      child: Divider(thickness: 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          OverflowBar(
            alignment: .end,
            children: [
              OutlinedButton(onPressed: controller.clear, child: Text(clearLabel)),
              TextButton(onPressed: onCancel, child: Text(cancelLabel)),
              TextButton(onPressed: submitSignature, child: Text(confirmLabel)),
            ],
          ),
        ],
      ),
    );
  }
}
