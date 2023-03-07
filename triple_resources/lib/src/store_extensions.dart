import 'package:flutter_triple/flutter_triple.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

import 'either_extensions.dart';

extension SigeStoreExtensions<Error extends Object, State extends Object> on Store<Error, State> {
  /// [executeEither] supporting [Either] from fpdart package
  Future<void> executeFpEither(
    Future<Either<Error, State>> Function() func, {
    Duration delay = Duration.zero,
  }) {
    return executeEither(() async {
      final result = await func();
      return result.toTripleEither();
    }, delay: delay);
  }

  /// [executeFpEither] for operations without a return value
  Future<void> launchFpEither(
    Future<Either<Error, Object?>> Function() func, {
    Duration delay = Duration.zero,
  }) {
    return executeFpEither(() async => (await func()).map((_) => state), delay: delay);
  }
}
