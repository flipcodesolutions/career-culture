import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_image_strings.dart';
import '../app_const/app_size.dart';
import 'cutom_loader.dart';

class CustomImageWithLoader extends StatelessWidget {
  const CustomImageWithLoader({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.errorIconSize,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? errorIconSize;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => showDialog(
            context: context,
            builder:
                (context) => Dialog(
                  child: InteractiveViewer(child: Image.network(imageUrl)),
                ),
          ),
      child: CachedNetworkImage(
        height: height,
        width: width,
        errorWidget:
            (context, url, error) => Icon(
              Icons.error_outline,
              color: AppColors.primary,
              size: errorIconSize ?? AppSize.size50,
            ),
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => Center(child: CustomLoader()),
        imageUrl: imageUrl,
      ),
    );
  }
}

class CustomLoaderImage extends StatelessWidget {
  const CustomLoaderImage({
    super.key,
    this.backGroundColor,
    required this.imageUrl,
    this.radius,
  });
  final Color? backGroundColor;
  final String imageUrl;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? AppSize.size50,
      backgroundColor: backGroundColor ?? AppColors.white,
      backgroundImage: AssetImage(AppImageStrings.spinner),
      foregroundImage: NetworkImage(imageUrl),
    );
  }
}
