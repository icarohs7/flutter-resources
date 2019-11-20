import 'package:flutter/material.dart';

class HeroAppBar extends PreferredSize {
  HeroAppBar({
    String heroTag = "toolbar",
    @required Widget title,
    List<Widget> actions,
    PreferredSizeWidget bottom,
  }) : super(
          preferredSize: Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
          child: _createAppBar(
            heroTag,
            title,
            actions,
            bottom,
          ),
        );

  static Widget _createAppBar(
    String heroTag,
    Widget title,
    List<Widget> actions,
    PreferredSizeWidget bottom,
  ) {
    final appBar = AppBar(
      title: title,
      centerTitle: true,
      actions: actions,
      bottom: bottom,
    );
    return heroTag != null ? Hero(tag: heroTag, child: appBar) : appBar;
  }
}
