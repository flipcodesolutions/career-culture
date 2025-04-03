import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import 'cutom_loader.dart';


class CustomImageWithLoader extends StatelessWidget {
  const CustomImageWithLoader(
      {super.key,
      required this.imageUrl,
      this.width,
      this.height,
      this.fit,
      this.errorIconSize});
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? errorIconSize;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        height: height,
        width: width,
        errorWidget: (context, url, error) => Icon(
              Icons.error_outline,
              color: AppColors.primary,
              size: errorIconSize ?? AppSize.size50,
            ),
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => Center(child: CustomLoader()),
        imageUrl: imageUrl);
  }
}
