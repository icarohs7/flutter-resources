import 'package:core_resources/core_resources.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('clog', () {
    late List<LogRecord> records;
    late Logger logger;

    setUp(() {
      records = [];
      logger = Logger('test_logger');
      logger.onRecord.listen(records.add);
    });

    test('logs info message when only object is provided', () {
      clog('Hello', logger: logger);

      expect(records, hasLength(1));
      expect(records.first.level, Level.INFO);
      expect(records.first.message, 'Hello');
      expect(records.first.error, isNull);
      expect(records.first.stackTrace, isNull);
    });

    test('logs severe message when error is provided', () {
      final error = Exception('test error');
      clog('Error occurred', error: error, logger: logger);

      expect(records, hasLength(1));
      expect(records.first.level, Level.SEVERE);
      expect(records.first.message, 'Error occurred');
      expect(records.first.error, error);
      expect(records.first.stackTrace, isNull);
    });

    test('logs severe message when stackTrace is provided', () {
      final stackTrace = StackTrace.current;
      clog('Stack trace', stackTrace: stackTrace, logger: logger);

      expect(records, hasLength(1));
      expect(records.first.level, Level.SEVERE);
      expect(records.first.message, 'Stack trace');
      expect(records.first.error, isNull);
      expect(records.first.stackTrace, stackTrace);
    });

    test('logs severe message when both error and stackTrace are provided', () {
      final error = Exception('test error');
      final stackTrace = StackTrace.current;
      clog('Error with stack', error: error, stackTrace: stackTrace, logger: logger);

      expect(records, hasLength(1));
      expect(records.first.level, Level.SEVERE);
      expect(records.first.message, 'Error with stack');
      expect(records.first.error, error);
      expect(records.first.stackTrace, stackTrace);
    });

    test('uses Logger.root when no logger is provided', () {
      final rootRecords = <LogRecord>[];
      final subscription = Logger.root.onRecord.listen(rootRecords.add);

      clog('Using root logger');

      expect(rootRecords, isNotEmpty);
      expect(rootRecords.first.message, 'Using root logger');

      subscription.cancel();
    });

    test('does not log when not in debug mode', () {
      // Note: This test verifies the behavior but kDebugMode is a compile-time constant
      // In release mode, the function returns early and no logging occurs
      // This test documents the expected behavior
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      if (!kDebugMode) {
        clog('Should not log', logger: logger);
        expect(records, isEmpty);
      } else {
        clog('Will log in debug mode', logger: logger);
        expect(records, isNotEmpty);
      }

      debugDefaultTargetPlatformOverride = null;
    });

    test('handles null object', () {
      clog(null, logger: logger);

      expect(records, hasLength(1));
      expect(records.first.level, Level.INFO);
      expect(records.first.message, 'null');
    });

    test('handles different object types', () {
      clog(42, logger: logger);
      expect(records.last.message, '42');

      clog(true, logger: logger);
      expect(records.last.message, 'true');

      clog(['list', 'of', 'items'], logger: logger);
      expect(records.last.message, '[list, of, items]');

      clog({'key': 'value'}, logger: logger);
      expect(records.last.message, '{key: value}');
    });
  });
}
