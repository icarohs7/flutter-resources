import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

///Image that shows a circular progress while loading and
///fade in smoothly when loaded
class FadeInAndLoadingNetworkImage extends StatelessWidget {
  const FadeInAndLoadingNetworkImage(
    this.imageUrl, {
    this.width,
    this.height,
  });

  final String imageUrl;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          placeholderCacheWidth: width ?? 15,
          image: 'https://$imageUrl',
          height: height,
          width: width,
        ),
      ],
    );
  }
}
