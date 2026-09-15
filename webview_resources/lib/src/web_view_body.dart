import 'package:material_ui/material_ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Displays a web view with progress feedback and an injectable error state.
class const WebViewBody({
  /// The controller used by the web view, or null when it could not be created.
  required final WebViewController? controller,

  /// Current navigation progress from 0 to 100.
  required final int loadingProgress,

  /// Label shown when [controller] is null and [loadErrorChild] is omitted.
  required final String errorLabel,

  /// Optional application-owned widget shown when [controller] is null.
  final Widget? loadErrorChild,
  super.key,
}) extends StatelessWidget {
  bool get _isLoading => loadingProgress < 100;

  @override
  Widget build(BuildContext context) {
    final webViewController = controller;
    if (webViewController == null) {
      return loadErrorChild ?? Center(child: Text(errorLabel));
    }

    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;

    return Stack(
      children: [
        IgnorePointer(
          ignoring: _isLoading,
          child: WebViewWidget(controller: webViewController),
        ),
        if (_isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: surfaceColor.withValues(alpha: 0.9),
              child: Stack(
                children: [
                  Align(
                    alignment: .topCenter,
                    child: LinearProgressIndicator(
                      value: loadingProgress / 100,
                      backgroundColor: surfaceColor,
                    ),
                  ),
                  Center(child: CircularProgressIndicator(color: theme.primaryColor)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
