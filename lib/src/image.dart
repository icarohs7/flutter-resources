import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> svgAssetToBitmapDescriptor(BuildContext context, String assetName) async {
  return await DefaultAssetBundle.of(context)
      .loadString(assetName)
      .then((svgString) => svg.fromSvgString(svgString, null))
      .then((drawableRoot) => drawableRoot.toPicture())
      .then((picture) => picture.toImage(26, 37))
      .then((image) => image.toByteData(format: ImageByteFormat.png))
      .then((bytes) => BitmapDescriptor.fromBytes(bytes.buffer.asUint8List()));
}
