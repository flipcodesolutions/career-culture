import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/widgets/custom_grid.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../utils/method_helpers/size_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_text.dart';

class MediaRender<T> extends StatelessWidget {
  MediaRender({
    super.key,
    required this.heading,
    this.isList = true,
    this.axisCountForGrid,
    required this.data,
    this.isNotScroll = false,
    required this.itemBuilder,
  });
  final String heading;
  final bool isList;
  final int? axisCountForGrid;
  final List<T> data;
  final bool isNotScroll;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  // Custom widget builder
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomContainer(
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          backGroundColor: AppColors.lightWhite,
          child: CustomText(
            text: heading,
            style: TextStyleHelper.smallHeading.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
        SizeHelper.height(),
        isList
            ? CustomContainer(
              child: Stack(
                children: [
                  CustomContainer(
                    height: 25.h,
                    width: 100.w,
                    child: PageView.builder(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final T item = data[index];
                        return itemBuilder(context, item, index);
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: LeftRIghtArrowPageViewBtn(
                      pageController: pageController,
                    ),
                  ),
                ],
              ),
            )
            : CustomGridWidget(
              isNotScroll: isNotScroll,
              axisCount: axisCountForGrid ?? 2,
              data: data,
              itemBuilder: (item, index) {
                final T item = data[index];
                return itemBuilder(context, item, index);
              },
            ),
        SizeHelper.height(),
      ],
    );
  }
}

class ArrowWidget extends StatelessWidget {
  const ArrowWidget({
    super.key,
    required this.onPressed,
    required this.isForword,
  });
  final bool isForword;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      constraints: BoxConstraints(
        maxHeight: AppSize.size40,
        maxWidth: AppSize.size40,
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.white),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: AppColors.grey.withOpacity(0.4),
            width: 1.5,
          ), // <-- Border color here
        ),
      ),
      color: AppColors.black,

      onPressed: onPressed,
      icon: Icon(
        isForword ? Icons.arrow_forward : Icons.arrow_back,
        size: AppSize.size20,
      ),
    );
  }
}

class LeftRIghtArrowPageViewBtn extends StatelessWidget {
  const LeftRIghtArrowPageViewBtn({
    super.key,
    required this.pageController,
    this.middleWidget,
  });

  final PageController pageController;
  final Widget? middleWidget;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ArrowWidget(
          isForword: false,
          onPressed:
              () => pageController.previousPage(
                duration: Durations.medium1,
                curve: Curves.decelerate,
              ),
        ),
        middleWidget ?? SizedBox.shrink(),
        ArrowWidget(
          isForword: true,
          onPressed:
              () => pageController.nextPage(
                duration: Durations.medium1,
                curve: Curves.decelerate,
              ),
        ),
      ],
    );
  }
}
