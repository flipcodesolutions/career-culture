import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_size.dart';

class CustomGridWidget<T> extends StatelessWidget {
  const CustomGridWidget({
    super.key,
    this.axisCount = 2,
    required this.data,
    required this.itemBuilder,
    this.isScroll = false,
  });
  final bool isScroll;
  final int axisCount;
  final List<T> data; // Generic data list
  final Widget Function(T item, int index) itemBuilder; // Custom widget builder

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: isScroll ? NeverScrollableScrollPhysics() : null,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: axisCount,
        crossAxisSpacing: AppSize.size10,
        mainAxisSpacing: AppSize.size10,
        childAspectRatio: 1,
      ),
      itemCount: data.length,
      itemBuilder:
          (context, index) =>
              itemBuilder(data[index], index), // Use passed builder
    );
  }
}
