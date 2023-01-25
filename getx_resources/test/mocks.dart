import 'package:getx_resources/getx_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'directory_utils.dart';

Future<void> startHiveWithMockDirectory() async {
  PathProviderPlatform.instance = FakePathProviderPlatform();
  await HiveDbResources.init((await getTempDir()).path);
}

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return 'applicationDocuments';
  }
}
