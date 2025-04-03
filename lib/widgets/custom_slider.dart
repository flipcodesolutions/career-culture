import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../utils/method_helpers/shadow_helper.dart';
import '../utils/navigation_helper/navigation_helper.dart';
import 'custom_container.dart';
import 'custom_image.dart';

class SliderRenderWidget extends StatelessWidget with NavigateHelper {
  final List items;
  const SliderRenderWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? SizedBox.shrink()
        : CustomContainer(
          child: CarouselSlider(
            items:
                items.map((image) {
                  return CustomContainer(
                   
                    borderRadius: BorderRadius.circular(AppSize.size10),
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      child: CustomImageWithLoader(
                        fit: BoxFit.cover,
                        imageUrl: "https://picsum.photos/seed/picsum/536/354",
                      ),
                    ),
                  );
                }).toList(),
            options: CarouselOptions(
              enableInfiniteScroll: false,
              viewportFraction: 1,
              height: 25.h,
              disableCenter: true,
              autoPlay: true,
              padEnds: true,
            ),
          ),
        );
  }
}
