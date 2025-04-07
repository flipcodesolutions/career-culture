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
  });
  final bool isNotScroll;
  final List<T> data; // Generic data list
  final Widget Function(T item, int index) itemBuilder; // Custom widget builder
  final Axis? scrollAxis;
  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        scrollDirection: scrollAxis ?? Axis.vertical,
        shrinkWrap: true,
        physics: isNotScroll ? NeverScrollableScrollPhysics() : null,
        padding: EdgeInsets.only(left: 5.w),
        itemCount: data.length,
        itemBuilder:
            (context, index) => AnimationConfiguration.staggeredList(
              position: index,
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
