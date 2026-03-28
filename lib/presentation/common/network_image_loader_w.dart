import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkImageLoader extends StatelessWidget {
  final String? url;

  const NetworkImageLoader({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url ?? '',
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: Colors.grey.shade900),
      errorWidget: (context, url, error) => ColoredBox(
        color: Colors.grey.shade900,
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.white38,
          size: 28.sp,
        ),
      ),
    );
  }
}
