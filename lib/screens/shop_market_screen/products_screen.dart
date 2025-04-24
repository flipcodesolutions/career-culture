import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_size.dart';
import '../../app_const/app_strings.dart';
import '../../models/product_model/product_model.dart';
import '../../utils/navigation_helper/navigation_helper.dart';
import '../../utils/text_style_helper/text_style_helper.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_text.dart';
import 'indiviual_product_screen.dart';

class ProductListPage extends StatelessWidget with NavigateHelper {
  final List<Product> products;

  const ProductListPage({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.products,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap:
                  () => push(
                    context: context,
                    widget: ProductPage(
                      name: product.name,
                      description: product.description,
                      price: product.price,
                      imageUrl: product.imageUrl,
                    ),
                    transition: FadeUpwardsPageTransitionsBuilder(),
                  ),
              child: CustomContainer(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                borderRadius: BorderRadius.circular(AppSize.size10),
                borderColor: AppColors.grey,
                borderWidth: 0.3,
                backGroundColor: AppColors.lightWhite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),
                        child: CustomImageWithLoader(
                          showImageInPanel: false,
                          imageUrl: product.imageUrl,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(AppSize.size10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: product.name,
                            style: TextStyleHelper.mediumHeading,
                          ),
                          CustomText(
                            text:
                                '${AppStrings.rupee} ${product.price.toStringAsFixed(2)}',
                            style: TextStyleHelper.smallHeading.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
