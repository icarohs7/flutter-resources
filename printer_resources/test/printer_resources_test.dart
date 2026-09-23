import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:printer_resources/printer_resources.dart';

void main() {
  group('EscPosPayload.build', () {
    test('initializes, selects code page 2, feeds five lines, and cuts', () {
      expect(EscPosPayload.build('Ticket\n'), latin1.encode('\x1B@\x1Bt2Ticket\n\x1Bd\x05\x1DV0'));
    });
  });

  group('PrintContentView', () {
    testWidgets('removes ESC/POS commands and control bytes but preserves text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PrintContentView('\x1B@\x1BE\x01Hello\x00\nWorld\x1D!\x01')),
      );

      final text = tester.widget<SelectableText>(find.byType(SelectableText));
      expect(text.data, 'Hello\nWorld');
      expect(text.style?.fontFamily, 'monospace');
    });
  });

  group('PrinterSocket.write', () {
    test('writes the complete payload when chunking is disabled', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final payload = utf8.encode(jsonEncode({'content': 'Ticket'}));
      final received = server.first.then((socket) async {
        final bytes = <int>[];
        await for (final chunk in socket) {
          bytes.addAll(chunk);
        }
        return bytes;
      });

      try {
        await PrinterSocket.write(
          InternetAddress.loopbackIPv4.address,
          server.port,
          data: payload,
          chunkData: false,
        );

        expect(await received, payload);
      } finally {
        await server.close();
      }
    });

    test('preserves all bytes when sending a chunked payload', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final payload = List<int>.generate(2500, (index) => index % 256);
      final received = server.first.then((socket) async {
        final bytes = <int>[];
        await for (final chunk in socket) {
          bytes.addAll(chunk);
        }
        return bytes;
      });

      try {
        await PrinterSocket.write(InternetAddress.loopbackIPv4.address, server.port, data: payload);

        expect(await received, payload);
      } finally {
        await server.close();
      }
    });

    test('marks a connection failure as definitely not sent', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final port = server.port;
      await server.close();

      await expectLater(
        PrinterSocket.write(InternetAddress.loopbackIPv4.address, port, data: const [1]),
        throwsA(
          isA<PrinterSocketException>().having(
            (failure) => failure.mayHaveSentData,
            'mayHaveSentData',
            isFalse,
          ),
        ),
      );
    });
  });
}
