import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';

class LoadingElevatedButton extends StatelessWidget {
  const LoadingElevatedButton({
    super.key,
    required this.onPressed,
    this.child,
    this.isLoading = false,
    this.style,
  });

  final Widget? child;
  final void Function()? onPressed;
  final bool isLoading;
  final ButtonStyle? style;

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
          foregroundColor: style?.foregroundColor?.resolve({}) ??
              (theme.useMaterial3 ? theme.primaryColor : theme.colorScheme.onPrimary),
          child: child,
        ),
      ),
    );
  }
}

class LoadingFilledButton extends StatelessWidget {
  const LoadingFilledButton({
    super.key,
    required this.onPressed,
    this.child,
    this.isLoading = false,
    this.style,
  });

  final Widget? child;
  final void Function()? onPressed;
  final bool isLoading;
  final ButtonStyle? style;

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
          foregroundColor: style?.foregroundColor?.resolve({}) ?? theme.colorScheme.onPrimary,
          child: child,
        ),
      ),
    );
  }
}

class LoadingTextButton extends StatelessWidget {
  const LoadingTextButton({
    super.key,
    required this.onPressed,
    this.child,
    this.isLoading = false,
    this.style,
  });

  final Widget? child;
  final void Function()? onPressed;
  final bool isLoading;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: TextButton(
        onPressed: onPressed,
        style: style,
        child: _ButtonContent(
          isLoading: isLoading,
          foregroundColor: style?.foregroundColor?.resolve({}) ?? context.theme.colorScheme.primary,
          child: child,
        ),
      ),
    );
  }
}

class LoadingFloatingActionButton extends StatelessWidget {
  const LoadingFloatingActionButton({
    super.key,
    required this.onPressed,
    this.child,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.shape,
    this.padding,
  });

  final Widget? child;
  final void Function()? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? padding;

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
          foregroundColor: foregroundColor ?? context.theme.colorScheme.onSecondary,
          child: child,
        ),
      ),
    );
  }
}

class LoadingIconButton extends StatelessWidget {
  const LoadingIconButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.color,
    this.progressIndicatorColor,
    this.padding,
  });

  final Widget? icon;
  final void Function()? onPressed;
  final bool isLoading;
  final Color? color;
  final Color? progressIndicatorColor;
  final EdgeInsetsGeometry? padding;

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
          foregroundColor: progressIndicatorColor,
          child: icon,
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.isLoading,
    required this.child,
    required this.foregroundColor,
  });

  final bool isLoading;
  final Widget? child;
  final Color? foregroundColor;

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
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
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
