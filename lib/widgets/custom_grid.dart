import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_size.dart';

class CustomGridWidget<T> extends StatelessWidget {
  const CustomGridWidget({
    super.key,
    this.axisCount = 2,
    required this.data,
    required this.itemBuilder,
    this.isNotScroll = false,
    this.padding,
    this.gridDelegate,
    this.childAspectRatio,
  });
  final bool isNotScroll;
  final int axisCount;
  final List<T> data; // Generic data list
  final Widget Function(T item, int index) itemBuilder; // Custom widget builder
  final EdgeInsetsGeometry? padding;
  final SliverGridDelegate? gridDelegate;
  final double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: isNotScroll ? NeverScrollableScrollPhysics() : null,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        gridDelegate:
            gridDelegate ??
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: axisCount,
              crossAxisSpacing: AppSize.size10,
              mainAxisSpacing: AppSize.size10,
              childAspectRatio: childAspectRatio ?? 1,
            ),
        itemCount: data.length,
        itemBuilder:
            (context, index) => AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: axisCount,
              child: ScaleAnimation(
                duration: Duration(milliseconds: 300),
                child: SlideAnimation(
                  horizontalOffset: 10.w,
                  duration: Duration(milliseconds: 300),
                  child: FadeInAnimation(
                    child: itemBuilder(data[index], index),
                  ),
                ),
              ),
            ), // Use passed builder
      ),
    );
  }
}
