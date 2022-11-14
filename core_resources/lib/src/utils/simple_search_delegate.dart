import 'package:flutter/material.dart';

abstract class SimpleSearchDelegate<T> extends SearchDelegate<T?> {
  SimpleSearchDelegate({this.enableSearchButton = false});

  final bool enableSearchButton;

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.backspace),
        onPressed: () => query = '',
      ),
      if (enableSearchButton)
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => onSearchButtonTapped(context),
        ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero);
    return Container();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  void onSearchButtonTapped(BuildContext context) {}
}
