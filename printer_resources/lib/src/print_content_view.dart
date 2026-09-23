import 'package:flutter/material.dart';

/// Shows printer content as selectable monospace text without known ESC/POS
/// commands or other non-printing control characters.
class const PrintContentView(final String content, {super.key}) extends StatelessWidget {
  static final _escPosCommands = RegExp(r'\x1B@\x1BE\x01|\x1B@|\x1D!\x01');
  static final _controlChars = RegExp(r'[\x00-\x09\x0B\x0C\x0E-\x1F]');

  @override
  Widget build(BuildContext context) {
    final clean = content.replaceAll(_escPosCommands, '').replaceAll(_controlChars, '');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SelectableText(clean, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
    );
  }
}
