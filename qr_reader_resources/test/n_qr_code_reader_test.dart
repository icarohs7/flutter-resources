import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_reader_resources/qr_reader_resources.dart';

void main() {
  testWidgets('renders the generic QR reader with configurable controls', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NQrCodeReader(
          onRead: (_, __) => QRReaderResponse.stopReading,
          backLabel: 'Return',
          showToggleFlashlightButton: false,
        ),
      ),
    );

    expect(find.byType(MobileScanner), findsOneWidget);
    expect(find.text('Return'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('uses no-duplicate detection when configured', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NQrCodeReader(
          allowDuplicates: false,
          onRead: (_, __) => QRReaderResponse.stopReading,
        ),
      ),
    );

    final scanner = tester.widget<MobileScanner>(find.byType(MobileScanner));
    expect(scanner.controller?.detectionSpeed, DetectionSpeed.noDuplicates);
  });
}
