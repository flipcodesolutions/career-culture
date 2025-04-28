import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sizer/sizer.dart';

class CustomListWidget<T> extends StatelessWidget {
  const CustomListWidget({
    super.key,
    required this.data,
    required this.itemBuilder,
    this.isNotScroll = false,
    this.scrollAxis,
    this.padding,
  });
  final bool isNotScroll;
  final List<T> data; // Generic data list
  final Widget Function(T item, int index) itemBuilder; // Custom widget builder
  final Axis? scrollAxis;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        scrollDirection: scrollAxis ?? Axis.vertical,
        shrinkWrap: true,
        physics: isNotScroll ? NeverScrollableScrollPhysics() : null,
        padding: padding ?? EdgeInsets.only(left: 5.w),
        itemCount: data.length,
        itemBuilder:
            (context, index) => AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                horizontalOffset: 50.w,
                duration: Duration(milliseconds: 500),
                child: FadeInAnimation(child: itemBuilder(data[index], index)),
              ),
            ), // Use passed builder
      ),
    );
  }
}
