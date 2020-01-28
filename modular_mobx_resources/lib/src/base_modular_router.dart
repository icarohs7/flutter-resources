import 'package:modular_mobx_resources/modular_mobx_resources.dart';

mixin BaseModularRouter {
  Future<T> go<T>(String route, {Object arguments}) {
    return Modular.to.pushNamed(route, arguments: arguments);
  }

  Future<T> goReplacement<T>(String route, {Object arguments}) {
    return Modular.to.pushReplacementNamed(route, arguments: arguments);
  }

  Future<T> goClearingBackstack<T>(String route, {Object arguments}) {
    return Modular.to.pushNamedAndRemoveUntil(route, (r) => false, arguments: arguments);
  }
}
