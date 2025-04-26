import 'package:flutter/material.dart';
import 'package:mindful_youth/models/product_model/product_model.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_size.dart';
import '../../app_const/app_strings.dart';
import '../../utils/method_helpers/size_helper.dart';
import '../../utils/text_style_helper/text_style_helper.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/primary_btn.dart';

class ProductPage extends StatefulWidget {
  final Product? product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _collapsed = false;
  // match your expandedHeight:
  final double _expandedHeight = 30.h;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.axis == Axis.vertical) {
            final shouldCollapse =
                n.metrics.pixels > (_expandedHeight - kToolbarHeight);
            if (shouldCollapse != _collapsed) {
              setState(() => _collapsed = shouldCollapse);
            }
          }
          return false;
        },
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverAppBar(
              expandedHeight: _expandedHeight,
              pinned: true,
              elevation: AppSize.size10,
              backgroundColor: AppColors.white,
              flexibleSpace: FlexibleSpaceBar(
                title: CustomText(
                  text: widget.product?.title ?? "",
                  style: TextStyleHelper.mediumHeading.copyWith(
                    color: _collapsed ? AppColors.primary : Colors.white,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomImageWithLoader(
                      imageUrl:
                          "${AppStrings.assetsUrl}${widget.product?.thumbnail}",
                    ),
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
                      text: widget.product?.title ?? "",
                      useOverflow: false,
                      style: TextStyleHelper.mediumHeading,
                    ),
                    SizeHelper.height(),
                    CustomText(
                      text: '${AppStrings.rupee} ${widget.product?.price}',
                      style: TextStyleHelper.smallHeading.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                child: CustomText(
                  text: widget.product?.description ?? "",
                  style: TextStyleHelper.smallText,
                  useOverflow: false,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: PrimaryBtn(btnText: AppStrings.buyNow, onTap: () {}),
      ),
    );
  }
}
