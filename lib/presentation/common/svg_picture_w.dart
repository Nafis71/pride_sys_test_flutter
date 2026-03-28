import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgPictureWidget extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;

  const SvgPictureWidget({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color ?? Colors.black, .srcIn),
    );
  }
}
