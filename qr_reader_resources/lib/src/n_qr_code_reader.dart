import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Displays a camera-based QR/barcode reader with configurable application UI.
///
/// The reader invokes [onRead] for each accepted capture. Return
/// [QRReaderResponse.continueReading] to keep scanning, or
/// [QRReaderResponse.stopReading] to finish. When scanning finishes,
/// [onFinish] is invoked after the optional navigator pop.
class const NQrCodeReader({
  /// Called whenever a code is read.
  final FutureOr<QRReaderResponse> Function(String? code, MobileScannerController controller)?
  onRead,

  /// Invoked with the last emitted code when reading finishes.
  final FutureOr<void> Function(String? lastCode, MobileScannerController controller)? onFinish,

  /// Whether to pop the current route when reading finishes.
  final bool navigatorPopWhenFinished = true,

  /// Whether the scanner may emit the same code more than once.
  final bool allowDuplicates = true,

  /// Minimum delay between scans when duplicates are allowed.
  final Duration debounceTime = const Duration(milliseconds: 200),

  /// Whether to show the bottom-right back button.
  final bool showBackButton = true,

  /// Label shown by the back button.
  final String backLabel = 'Back',

  /// Whether to show the top-right flashlight button.
  final bool showToggleFlashlightButton = true,

  /// Camera used by the scanner.
  final CameraFacing camera = CameraFacing.back,

  /// Barcode formats accepted by the scanner.
  final List<BarcodeFormat> formats = const [],

  /// Border color for the scan area indicator.
  final Color borderColor = Colors.red,

  /// Color of the flashlight button while the flashlight is on.
  final Color flashlightOnColor = Colors.green,

  /// Color of the flashlight button while the flashlight is off.
  final Color flashlightOffColor = Colors.red,
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final controller = useMemoized(
      () => MobileScannerController(
        facing: camera,
        detectionSpeed: allowDuplicates ? DetectionSpeed.normal : DetectionSpeed.noDuplicates,
        detectionTimeoutMs: debounceTime.inMilliseconds,
        formats: formats,
      ),
    );

    useEffect(() {
      if (controller.facing == camera) return null;
      controller.switchCamera();
      return null;
    }, [camera]);

    useEffect(() {
      var isProcessing = false;
      late final StreamSubscription<BarcodeCapture> subscription;
      subscription = controller.barcodes.listen((capture) async {
        if (isProcessing) return;
        isProcessing = true;

        try {
          final readCode = capture.barcodes.isEmpty ? null : capture.barcodes.first.rawValue;
          final readFn =
              onRead ??
              (code, controller) =>
                  code == null ? QRReaderResponse.continueReading : QRReaderResponse.stopReading;
          final response = await runAsyncOrDefault(
            QRReaderResponse.stopReading,
            () => readFn(readCode, controller),
          );
          final continueProcessing = response == QRReaderResponse.continueReading;

          if (!continueProcessing) {
            await subscription.cancel();
            if (navigatorPopWhenFinished && context.mounted) context.pop(readCode);
            await onFinish?.call(readCode, controller);
          }
        } finally {
          isProcessing = false;
        }
      });

      return () {
        subscription.cancel();
        controller.dispose();
      };
    }, [controller]);

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: (_) {}),
          Center(
            child: CustomPaint(
              foregroundPainter: NQrCodeScannerBorderPainter(color: borderColor),
              child: SizedBox(width: size.width * 0.8, height: size.width * 0.8),
            ),
          ),
          if (showToggleFlashlightButton)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Align(
                alignment: .topRight,
                child: HookBuilder(
                  builder: (context) {
                    final flashOn = useValueListenable(controller).torchState == TorchState.on;

                    return _NFlashlightButton(
                      isFlashlightOn: flashOn,
                      onColor: flashlightOnColor,
                      offColor: flashlightOffColor,
                      toggleFlashlight: controller.toggleTorch,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: !showBackButton
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Colors.transparent,
              elevation: 0,
              icon: Icon(Icons.arrow_back),
              label: Text(backLabel),
              onPressed: context.pop,
            ),
    );
  }
}

/// Draws the corner markers around a QR/barcode scan area.
class const NQrCodeScannerBorderPainter({final Color color = Colors.red}) extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final borderSize = width * 0.2;
    const strokeWidth = 4.0;

    final borderPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = .stroke;

    final borderPath = Path()
      // Top left
      ..moveTo(0, 0)
      ..addPolygon([Offset(borderSize, 0), Offset(0, 0), Offset(0, borderSize)], false)
      // Top right
      ..moveTo(width, 0)
      ..addPolygon([
        Offset(width - borderSize, 0),
        Offset(width, 0),
        Offset(width, borderSize),
      ], false)
      // Bottom right
      ..moveTo(width, height)
      ..addPolygon([
        Offset(width, height - borderSize),
        Offset(width, height),
        Offset(width - borderSize, height),
      ], false)
      // Bottom left
      ..moveTo(0, height)
      ..addPolygon([
        Offset(0, height - borderSize),
        Offset(0, height),
        Offset(borderSize, height),
      ], false);

    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(NQrCodeScannerBorderPainter oldDelegate) => color != oldDelegate.color;

  @override
  bool shouldRebuildSemantics(NQrCodeScannerBorderPainter oldDelegate) => false;
}

class const _NFlashlightButton({
  required final bool isFlashlightOn,
  required final Color onColor,
  required final Color offColor,
  required final void Function() toggleFlashlight,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FilledButton(
        style: FilledButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: isFlashlightOn ? onColor : offColor,
          foregroundColor: Colors.white,
        ),
        onPressed: toggleFlashlight,
        child: isFlashlightOn
            ? Icon(Icons.flash_on, key: ValueKey('icon_on'))
            : Icon(Icons.flash_off, key: ValueKey('icon_off')),
      ),
    );
  }
}

/// Result returned by [NQrCodeReader.onRead].
enum QRReaderResponse() {
  /// Continue waiting for another code.
  continueReading,

  /// Stop reading and invoke [NQrCodeReader.onFinish].
  stopReading,
}
