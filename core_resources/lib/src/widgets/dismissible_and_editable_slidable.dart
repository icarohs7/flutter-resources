import 'package:material_ui/material_ui.dart';

class const DismissibleAndEditableSlidable({
  super.key,
  required final Key itemKey,
  required final void Function() onDismissed,
  required final void Function() onEdited,
  required final Widget child,
  final Future<bool> Function()? confirmDismiss,
  final Widget? backgroundDismiss,
  final Widget? backgroundEdit,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: itemKey,
      direction: .horizontal,
      confirmDismiss: (direction) async {
        switch (direction) {
          case .endToStart:
            return (await confirmDismiss?.call()) ?? true;
          case .startToEnd:
            onEdited();
            return false;
          default:
            return true;
        }
      },
      onDismissed: (direction) => onDismissed(),
      secondaryBackground:
          backgroundDismiss ??
          Container(
            alignment: Alignment.centerRight,
            color: .new(0xFFE3000F),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.delete, size: 24, color: Colors.white),
            ),
          ),
      background:
          backgroundEdit ??
          Container(
            alignment: Alignment.centerLeft,
            color: Colors.blue,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.edit, size: 24, color: Colors.white),
            ),
          ),
      child: child,
    );
  }
}
