import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_size.dart';
import '../../app_const/app_strings.dart';
import '../../utils/method_helpers/size_helper.dart';
import '../../utils/text_style_helper/text_style_helper.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/primary_btn.dart';

class ProductPage extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  const ProductPage({
    Key? key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: [
          SliverAppBar(
            expandedHeight: 30.h,
            pinned: true,
            elevation: AppSize.size10,
            backgroundColor: AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: CustomText(text: name, style: TextStyleHelper.mediumText),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CustomImageWithLoader(imageUrl: imageUrl),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black26],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: name,
                    useOverflow: false,
                    style: TextStyleHelper.mediumHeading,
                  ),
                  SizeHelper.height(),
                  CustomText(
                    text: '\$${price.toStringAsFixed(2)}',
                    style: TextStyleHelper.smallHeading.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: CustomText(
                text: description,
                style: TextStyleHelper.smallText,
                useOverflow: false,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: PrimaryBtn(btnText: AppStrings.buyNow, onTap: () {}),
      ),
    );
  }
}
