part of unox_flutter_core_resources;

class Navigation {
  static void push(
    BuildContext context, {
    Widget Function(BuildContext context) builder,
    Widget destination,
    bool fullscreenDialog = false,
  }) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: builder ?? (_) => destination,
      fullscreenDialog: fullscreenDialog,
    ));
  }

  static void pushReplacement(
    BuildContext context, {
    Widget Function(BuildContext context) builder,
    Widget destination,
    bool fullscreenDialog = false,
  }) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: builder ?? (_) => destination,
      fullscreenDialog: fullscreenDialog,
    ));
  }
}
