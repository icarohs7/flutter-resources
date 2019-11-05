part of core_resources;

class HeroAppBar extends PreferredSize {
  HeroAppBar({
    String heroTag = "toolbar",
    @required Widget title,
    List<Widget> actions,
  }) : super(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: _createAppBar(
            heroTag,
            title,
            actions,
          ),
        );

  static Widget _createAppBar(
    String heroTag,
    Widget title,
    List<Widget> actions,
  ) {
    final appBar = AppBar(
      title: title,
      centerTitle: true,
      actions: actions,
    );
    return heroTag != null ? Hero(tag: heroTag, child: appBar) : appBar;
  }
}
