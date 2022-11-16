import '../../getx_core_resources.dart';

extension GCRGetExtensions on GetInterface {
  /// Shortcut to [Get.put] setting the [permanent] parameter as true
  T putSingleton<T>(T dependency, {String? tag, InstanceBuilderCallback<T>? builder}) {
    return put<T>(dependency, tag: tag, permanent: true, builder: builder);
  }
}
