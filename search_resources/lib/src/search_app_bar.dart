import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

class const SearchAppBar({
  super.key,
  required final Widget title,
  final bool centerTitle = false,
  final List<Widget>? actions,
  final String hintText = 'Pesquisa',
  required final bool isSearching,
  required final ValueChanged<bool> onSearchToggled,
  required final ValueChanged<String> onSearchChange,
}) extends HookWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();

    useEffect(() {
      return () {
        onSearchChange('');
        onSearchToggled(false);
      };
    }, []);

    return AppBar(
      title: isSearching
          ? TextField(
              key: UniqueKey(),
              controller: searchController,
              autofocus: true,
              decoration: .new(hintText: hintText, border: .none),
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
