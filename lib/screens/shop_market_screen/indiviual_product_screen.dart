import 'package:flutter/material.dart';
import 'package:mindful_youth/models/product_model/product_model.dart';
import 'package:mindful_youth/provider/product_provider/product_provider.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_size.dart';
import '../../app_const/app_strings.dart';
import '../../utils/method_helpers/size_helper.dart';
import '../../utils/method_helpers/validator_helper.dart';
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

class _ProductPageState extends State<ProductPage> with NavigateHelper {
  bool _collapsed = false;
  // match your expandedHeight:
  final double _expandedHeight = 30.h;
  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch<ProductProvider>();
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
                    PageView.builder(
                      itemCount:
                          productProvider
                              .getListImage(product: widget.product)
                              .length,
                      itemBuilder:
                          (context, index) => DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black26],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: CustomImageWithLoader(
                              imageUrl:
                                  "${AppStrings.assetsUrl}${productProvider}",
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
                      text:
                          '${AppStrings.rupee} ${productProvider.orderModel?.price}',
                      style: TextStyleHelper.smallHeading.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizeHelper.height(),
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
      bottomNavigationBar: CustomContainer(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: AppStrings.qty,
                  style: TextStyleHelper.smallHeading.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                QtyIncrementDecrement(product: widget.product),
              ],
            ),
            SizeHelper.height(height: 1.h),
            PrimaryBtn(
              btnText: AppStrings.buyNow,
              width: 90.w,
              onTap:
                  () => showModalBottomSheet(
                    backgroundColor: AppColors.white,
                    context: context,
                    builder: (context) => OrderSheet(product: widget.product),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

///
class QtyIncrementDecrement extends StatelessWidget {
  const QtyIncrementDecrement({super.key, required this.product});
  final Product? product;
  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch<ProductProvider>();
    return Row(
      children: [
        CustomContainer(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap:
                    () => productProvider.changeQty(
                      add: true,
                      price: int.tryParse(product?.price ?? "0") ?? 0,
                    ),
                child: CustomContainer(
                  borderWidth: 0.5,
                  borderColor: AppColors.primary,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(5),
                  ),

                  width: 10.w,
                  height: 5.h,
                  child: Icon(Icons.add, color: AppColors.primary),
                ),
              ),
              CustomContainer(
                border: Border.symmetric(
                  horizontal: BorderSide(color: AppColors.primary, width: 0.5),
                ),
                alignment: Alignment.center,
                width: 10.w,
                height: 5.h,
                child: CustomText(
                  text: productProvider.orderModel?.qty.toString() ?? "",
                  style: TextStyleHelper.mediumHeading.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              InkWell(
                onTap:
                    () => productProvider.changeQty(
                      add: false,
                      price: int.tryParse(product?.price ?? "0") ?? 0,
                    ),
                child: CustomContainer(
                  borderWidth: 0.5,
                  borderColor: AppColors.primary,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(5),
                  ),

                  width: 10.w,
                  height: 5.h,
                  child: Icon(Icons.remove, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderSheet extends StatelessWidget with NavigateHelper {
  const OrderSheet({super.key, required this.product});
  final Product? product;
  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch<ProductProvider>();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: CustomContainer(
        padding: EdgeInsets.all(AppSize.size10),
        child: SingleChildScrollView(
          child: Form(
            key: productProvider.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// text
                CustomText(
                  text: product?.title ?? "",
                  style: TextStyleHelper.mediumHeading.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizeHelper.height(),

                /// address
                CustomTextFormField(
                  labelText: AppStrings.address,
                  hintText: AppStrings.address,
                  controller: productProvider.addressController,
                  validator:
                      (value) => ValidatorHelper.validateValue(
                        value: value,
                        context: context,
                      ),
                ),
                SizeHelper.height(),

                productProvider.isLoading
                    ? Center(child: CustomLoader())
                    : PrimaryBtn(
                      width: 90.w,
                      btnText:
                          "${AppStrings.placeOrder} (${AppStrings.rupee} ${productProvider.orderModel?.price ?? ""})",
                      onTap: () async {
                        if (productProvider.formKey.currentState?.validate() ??
                            false) {
                          bool success = await productProvider.order(
                            context: context,
                            product: product,
                          );
                          if (success) {
                            pop(context);
                          }
                        }
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
