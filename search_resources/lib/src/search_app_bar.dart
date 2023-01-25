import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

class SearchAppBar extends HookWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final String hintText;
  final ValueChanged<String> onSearchChange;

  const SearchAppBar({
    super.key,
    required this.title,
    this.actions,
    this.hintText = 'Pesquisa',
    required this.onSearchChange,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isSearching = useState(false);
    final searchController = useTextEditingController();

    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isSearching.value
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
      ),
      actions: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isSearching.value
              ? IconButton(
                  key: UniqueKey(),
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    isSearching.value = false;
                    searchController.clear();
                    onSearchChange('');
                  },
                )
              : IconButton(
                  key: UniqueKey(),
                  icon: const Icon(Icons.search),
                  onPressed: () => isSearching.value = true,
                ),
        ),
        ...?actions,
      ],
    );
  }
}
