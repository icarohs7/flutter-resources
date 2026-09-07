import 'package:material_ui/material_ui.dart';

class const DismissibleFromEndToStart({
  super.key,
  required final Key itemKey,
  required final void Function() onDismissed,
  required final Widget child,
  final Future<bool> Function()? confirmDismiss,
  final Widget? background,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: itemKey,
      direction: .endToStart,
      confirmDismiss: (_) => confirmDismiss?.call() ?? Future.value(true),
      onDismissed: (_) => onDismissed(),
      background:
          background ??
          Container(
            alignment: Alignment.centerRight,
            color: .new(0xFFE3000F),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.delete, size: 24, color: Colors.white),
            ),
          ),
      child: child,
    );
  }
}
