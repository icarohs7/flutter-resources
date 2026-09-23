import 'dart:convert';

/// Builds the standard ESC/POS payload used for raw thermal-printer output.
///
/// The payload initializes the printer, selects code page 2, appends [content],
/// feeds five lines, and performs a full cut.
abstract final class EscPosPayload() {
  /// Builds an ESC/POS byte payload for [content].
  ///
  /// Text outside the Latin-1 range is rejected by [latin1.encode].
  static List<int> build(String content) => [
    ...'\x1B@'.codeUnits,
    ...latin1.encode('\x1Bt2'),
    ...latin1.encode(content),
    ...'\x1Bd'.codeUnits,
    5,
    ...'\x1DV0'.codeUnits,
  ];
}
