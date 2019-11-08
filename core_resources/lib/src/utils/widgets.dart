import 'package:flutter/cupertino.dart';

RelativeRect getWidgetPositionAsRelativeRect(BuildContext context, {Offset offset}) {
  final RenderBox inkWell = context.findRenderObject();
  final RenderBox overlay = Overlay.of(context).context.findRenderObject();
  return RelativeRect.fromRect(
    Rect.fromPoints(
      inkWell.localToGlobal(offset ?? Offset.zero, ancestor: overlay),
      inkWell.localToGlobal(inkWell.size.bottomRight(Offset.zero), ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );
}
