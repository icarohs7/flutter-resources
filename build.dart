// ignore_for_file: avoid_print

import 'dart:io';

void main() async {
  final packages = await getPackages().toList();

  var errorCount = 0;
  for (final packageDir in packages) {
    print('\n\nBuilding $packageDir...\n');

    final commands = ['flutter packages get', 'flutter analyze', 'flutter test --coverage'];

    var packageFailed = false;
    for (final command in commands) {
      final returnCode = await runCommand(command, workingDirectory: packageDir);
      if (returnCode != 0) {
        packageFailed = true;
        break;
      }
    }

    if (packageFailed) {
      errorCount++;
      print('$packageDir failed to build');
    } else {
      print('$packageDir built successfully');
    }
    print('=================================================\n');
  }

  final packageCount = packages.length;
  print('=================================================\n');
  print('${packageCount - errorCount}/$packageCount modules succeeded building');
  print('=================================================\n');

  if (errorCount > 0) exit(1);
}

Stream<String> getPackages() async* {
  await for (final entity in Directory.current.list(recursive: true)) {
    if (entity is Directory) {
      final pubspecFile = File('${entity.path}/pubspec.yaml');
      if (await pubspecFile.exists()) yield entity.path;
    }
  }
}

Future<int> runCommand(String command, {String? workingDirectory}) async {
  final parts = command.split(' ');
  final executable = parts.first;
  final arguments = parts.skip(1).toList();

  final result = await Process.run(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    runInShell: true,
  );

  if (result.stdout.toString().isNotEmpty) stdout.write(result.stdout);
  if (result.stderr.toString().isNotEmpty) stderr.write(result.stderr);

  if (result.exitCode != 0) {
    print('Command failed: $command');
    print('Exit code: ${result.exitCode}');
  }

  print('');
  return result.exitCode;
}
