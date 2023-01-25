import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

class SearchAppBar extends HookWidget implements PreferredSizeWidget {
  final Widget title;
  final bool centerTitle;
  final List<Widget>? actions;
  final String hintText;
  final bool isSearching;
  final ValueChanged<bool> onSearchToggled;
  final ValueChanged<String> onSearchChange;

  const SearchAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.actions,
    this.hintText = 'Pesquisa',
    required this.isSearching,
    required this.onSearchToggled,
    required this.onSearchChange,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();

    useEffect(() {
      return () => onSearchToggled(false);
    }, []);

    return AppBar(
      title: isSearching
          ? TextField(
              key: UniqueKey(),
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
              onChanged: onSearchChange,
            )
          : title,
      centerTitle: centerTitle,
      actions: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isSearching
              ? IconButton(
                  key: UniqueKey(),
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    onSearchToggled(false);
                    searchController.clear();
                    onSearchChange('');
                  },
                )
              : IconButton(
                  key: UniqueKey(),
                  icon: const Icon(Icons.search),
                  onPressed: () => onSearchToggled(true),
                ),
        ),
        ...?actions,
      ],
    );
  }
}
