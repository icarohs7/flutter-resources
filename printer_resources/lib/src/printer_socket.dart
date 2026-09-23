import 'dart:io';

/// A failure from [PrinterSocket.write].
///
/// If [mayHaveSentData] is true, some or all bytes may have reached the
/// recipient. TCP provides no printer-level acknowledgement, so callers
/// should not automatically retry an ambiguous write.
class const PrinterSocketException({
  /// The underlying connection or write error.
  required final Object error,

  /// The stack trace captured at the transport failure.
  required final StackTrace stackTrace,

  /// Whether the socket connected before the failure occurred.
  required final bool mayHaveSentData,
}) implements Exception {
  @override
  String toString() => 'PrinterSocketException($error)';
}

/// Sends raw bytes to a printer over TCP.
abstract final class PrinterSocket() {
  /// Standard port used by raw ESC/POS printers.
  static const rawPort = 9100;

  static const _chunkSize = 1024;
  static const _chunkDelay = Duration(milliseconds: 50);
  static const _closeDelay = Duration(milliseconds: 300);

  /// Connects to [host]:[port], writes [data], and closes the socket.
  ///
  /// By default, data is sent in 1024-byte chunks with a short delay to avoid
  /// overflowing small printer buffers. Set [chunkData] to false when the
  /// receiver expects one deliberate write; TCP may still fragment that data.
  /// [timeout] defaults to two seconds. Failures are reported as
  /// [PrinterSocketException], distinguishing connection failures from
  /// failures after the socket connected.
  static Future<void> write(
    String host,
    int port, {
    Duration? timeout,
    required List<int> data,
    bool chunkData = true,
  }) async {
    final Socket socket;
    try {
      socket = await Socket.connect(host, port, timeout: timeout ?? const Duration(seconds: 2));
    } catch (error, stackTrace) {
      throw PrinterSocketException(error: error, stackTrace: stackTrace, mayHaveSentData: false);
    }

    try {
      if (chunkData) {
        for (var i = 0; i < data.length; i += _chunkSize) {
          final end = i + _chunkSize < data.length ? i + _chunkSize : data.length;
          socket.add(data.sublist(i, end));
          await socket.flush();
          await Future.delayed(_chunkDelay);
        }
      } else {
        socket.add(data);
        await socket.flush();
      }

      await Future.delayed(_closeDelay);
      await socket.close();
    } catch (error, stackTrace) {
      socket.destroy();
      throw PrinterSocketException(error: error, stackTrace: stackTrace, mayHaveSentData: true);
    }
  }
}
