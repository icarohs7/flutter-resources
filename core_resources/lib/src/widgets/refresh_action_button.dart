import 'package:material_ui/material_ui.dart';

/// Refresh icon button that turns into a
/// [CircularProgressIndicator] according to
/// the parameter [isRefreshing], also disabling
/// its [onTap] when true
class const RefreshActionButton({
  super.key,
  final bool isRefreshing = false,
  final void Function()? onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isRefreshing
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
                strokeWidth: 2,
              ),
            )
          : Icon(Icons.refresh),
      onPressed: isRefreshing ? null : onTap,
    );
  }
}
