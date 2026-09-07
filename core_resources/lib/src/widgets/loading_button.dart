import 'package:material_ui/material_ui.dart';

import '../extensions/context_extensions.dart';

class const LoadingElevatedButton({
  super.key,
  required final void Function()? onPressed,
  final Widget? child,
  final bool isLoading = false,
  final ButtonStyle? style,
  final double progressIndicatorHeight = 16,
  final double progressIndicatorWidth = 16,
  final double progressIndicatorStrokeWidth = 2,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return AbsorbPointer(
      absorbing: isLoading,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: _ButtonContent(
          isLoading: isLoading,
          progressIndicatorHeight: progressIndicatorHeight,
          progressIndicatorWidth: progressIndicatorWidth,
          progressIndicatorStrokeWidth: progressIndicatorStrokeWidth,
          foregroundColor:
              style?.foregroundColor?.resolve({}) ??
              (theme.useMaterial3 ? theme.primaryColor : theme.colorScheme.onPrimary),
          child: child,
        ),
      ),
    );
  }
}

class const LoadingFilledButton({
  super.key,
  required final void Function()? onPressed,
  final Widget? child,
  final bool isLoading = false,
  final ButtonStyle? style,
  final double progressIndicatorHeight = 16,
  final double progressIndicatorWidth = 16,
  final double progressIndicatorStrokeWidth = 2,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return AbsorbPointer(
      absorbing: isLoading,
      child: FilledButton(
        onPressed: onPressed,
        style: style,
        child: _ButtonContent(
          isLoading: isLoading,
          progressIndicatorHeight: progressIndicatorHeight,
          progressIndicatorWidth: progressIndicatorWidth,
          progressIndicatorStrokeWidth: progressIndicatorStrokeWidth,
          foregroundColor: style?.foregroundColor?.resolve({}) ?? theme.colorScheme.onPrimary,
          child: child,
        ),
      ),
    );
  }
}

class const LoadingTextButton({
  super.key,
  required final void Function()? onPressed,
  final Widget? child,
  final bool isLoading = false,
  final ButtonStyle? style,
  final double progressIndicatorHeight = 16,
  final double progressIndicatorWidth = 16,
  final double progressIndicatorStrokeWidth = 2,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: TextButton(
        onPressed: onPressed,
        style: style,
        child: _ButtonContent(
          isLoading: isLoading,
          progressIndicatorHeight: progressIndicatorHeight,
          progressIndicatorWidth: progressIndicatorWidth,
          progressIndicatorStrokeWidth: progressIndicatorStrokeWidth,
          foregroundColor: style?.foregroundColor?.resolve({}) ?? context.theme.colorScheme.primary,
          child: child,
        ),
      ),
    );
  }
}

class const LoadingFloatingActionButton({
  super.key,
  required final void Function()? onPressed,
  final Widget? child,
  final bool isLoading = false,
  final Color? backgroundColor,
  final Color? foregroundColor,
  final ShapeBorder? shape,
  final EdgeInsetsGeometry? padding,
  final double progressIndicatorHeight = 16,
  final double progressIndicatorWidth = 16,
  final double progressIndicatorStrokeWidth = 2,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: FloatingActionButton(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        onPressed: onPressed,
        shape: shape,
        child: _ButtonContent(
          isLoading: isLoading,
          progressIndicatorHeight: progressIndicatorHeight,
          progressIndicatorWidth: progressIndicatorWidth,
          progressIndicatorStrokeWidth: progressIndicatorStrokeWidth,
          foregroundColor: foregroundColor ?? context.theme.colorScheme.onSecondary,
          child: child,
        ),
      ),
    );
  }
}

class const LoadingIconButton({
  super.key,
  required final void Function()? onPressed,
  final Widget? icon,
  final bool isLoading = false,
  final Color? color,
  final double progressIndicatorHeight = 16,
  final double progressIndicatorWidth = 16,
  final double progressIndicatorStrokeWidth = 2,
  final Color? progressIndicatorColor,
  final EdgeInsetsGeometry? padding,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: IconButton(
        onPressed: onPressed,
        color: color,
        padding: padding,
        icon: _ButtonContent(
          isLoading: isLoading,
          progressIndicatorHeight: progressIndicatorHeight,
          progressIndicatorWidth: progressIndicatorWidth,
          progressIndicatorStrokeWidth: progressIndicatorStrokeWidth,
          foregroundColor: progressIndicatorColor,
          child: icon,
        ),
      ),
    );
  }
}

class const _ButtonContent({
  required final bool isLoading,
  required final Widget? child,
  required final double progressIndicatorHeight,
  required final double progressIndicatorWidth,
  required final double progressIndicatorStrokeWidth,
  required final Color? foregroundColor,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      duration: .new(milliseconds: 300),
      child: isLoading
          ? Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Opacity(opacity: 0, child: child),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: SizedBox(
                    height: progressIndicatorHeight,
                    width: progressIndicatorWidth,
                    child: CircularProgressIndicator(
                      strokeWidth: progressIndicatorStrokeWidth,
                      color: foregroundColor,
                    ),
                  ),
                ),
              ],
            )
          : child,
    );
  }
}
