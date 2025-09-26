import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';

class LoadingElevatedButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onPressed;
  final bool isLoading;
  final ButtonStyle? style;
  final double progressIndicatorHeight;
  final double progressIndicatorWidth;
  final double progressIndicatorStrokeWidth;

  const LoadingElevatedButton({
    super.key,
    required this.onPressed,
    this.child,
    this.isLoading = false,
    this.style,
    this.progressIndicatorHeight = 16,
    this.progressIndicatorWidth = 16,
    this.progressIndicatorStrokeWidth = 2,
  });

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
          foregroundColor: style?.foregroundColor?.resolve({}) ??
              (theme.useMaterial3 ? theme.primaryColor : theme.colorScheme.onPrimary),
          child: child,
        ),
      ),
    );
  }
}

class LoadingFilledButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onPressed;
  final bool isLoading;
  final ButtonStyle? style;
  final double progressIndicatorHeight;
  final double progressIndicatorWidth;
  final double progressIndicatorStrokeWidth;

  const LoadingFilledButton({
    super.key,
    required this.onPressed,
    this.child,
    this.isLoading = false,
    this.style,
    this.progressIndicatorHeight = 16,
    this.progressIndicatorWidth = 16,
    this.progressIndicatorStrokeWidth = 2,
  });

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

class LoadingTextButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onPressed;
  final bool isLoading;
  final ButtonStyle? style;
  final double progressIndicatorHeight;
  final double progressIndicatorWidth;
  final double progressIndicatorStrokeWidth;

  const LoadingTextButton({
    super.key,
    required this.onPressed,
    this.child,
    this.isLoading = false,
    this.style,
    this.progressIndicatorHeight = 16,
    this.progressIndicatorWidth = 16,
    this.progressIndicatorStrokeWidth = 2,
  });

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

class LoadingFloatingActionButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? padding;
  final double progressIndicatorHeight;
  final double progressIndicatorWidth;
  final double progressIndicatorStrokeWidth;

  const LoadingFloatingActionButton({
    super.key,
    required this.onPressed,
    this.child,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.shape,
    this.padding,
    this.progressIndicatorHeight = 16,
    this.progressIndicatorWidth = 16,
    this.progressIndicatorStrokeWidth = 2,
  });

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

class LoadingIconButton extends StatelessWidget {
  final Widget? icon;
  final void Function()? onPressed;
  final bool isLoading;
  final Color? color;
  final double progressIndicatorHeight;
  final double progressIndicatorWidth;
  final double progressIndicatorStrokeWidth;
  final Color? progressIndicatorColor;
  final EdgeInsetsGeometry? padding;

  const LoadingIconButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.color,
    this.progressIndicatorHeight = 16,
    this.progressIndicatorWidth = 16,
    this.progressIndicatorStrokeWidth = 2,
    this.progressIndicatorColor,
    this.padding,
  });

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

class _ButtonContent extends StatelessWidget {
  final bool isLoading;
  final Widget? child;
  final double progressIndicatorHeight;
  final double progressIndicatorWidth;
  final double progressIndicatorStrokeWidth;
  final Color? foregroundColor;

  const _ButtonContent({
    required this.isLoading,
    required this.child,
    required this.progressIndicatorHeight,
    required this.progressIndicatorWidth,
    required this.progressIndicatorStrokeWidth,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      duration: Duration(milliseconds: 300),
      child: isLoading
          ? Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Opacity(
                  opacity: 0,
                  child: child,
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Container(
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
