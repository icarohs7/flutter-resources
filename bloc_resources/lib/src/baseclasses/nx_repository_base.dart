part of bloc_resources;

class NxRepositoryBase<DaoT> {
  DaoT get dao => _dao.v;
  final _dao = Lazy(() => Inject(tag: "AppModule").get<DaoT>());
}
