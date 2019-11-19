import 'package:rest_resources/rest_resources.dart';

const RestResources = _RestResources();
final _alice = Alice(showNotification: true, darkTheme: true);

class _RestResources {
  const _RestResources();

  Alice get alice => _alice;
}
