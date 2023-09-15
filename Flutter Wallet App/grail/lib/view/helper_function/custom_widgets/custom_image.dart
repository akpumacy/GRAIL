import 'package:flutter/material.dart';

import '../../../utils/cache/cache_image_widget2.dart';

class CommonProfileImage extends StatelessWidget {
  const CommonProfileImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.needPlaceH = true,
  }) : super(key: key);

  final String imageUrl;
  final int? width;
  final int? height;
  final bool needPlaceH;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage2(
      imageUrl: imageUrl,
      // memCacheWidth: width,
      // memCacheHeight: height,
      fit: BoxFit.cover,
      cacheManager: defaultCacheManager,
      placeholder: (context, url) => needPlaceH
          ? const Icon(
              Icons.person,
              size: 50,
              color: Colors.grey,
            )
          : Container(),
      errorWidget: (context, url, error) => needPlaceH
          ? const Icon(
              Icons.person,
              size: 50,
              color: Colors.grey,
            )
          : Container(),
    );
  }
}
