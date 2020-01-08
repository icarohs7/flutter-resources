import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:core_resources/core_resources.dart';

class NxRepositoryBase<DaoT> {
  DaoT get dao => _dao.v;
  final _dao = Lazy(() => Inject(tag: 'AppModule').get<DaoT>());

  Object logError(dynamic e) {
    print('Error on $runtimeType => ${e?.response?.body ?? e}');
    return null;
  }
}
