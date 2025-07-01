import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/models/product_model/create_order_model.dart';
import 'package:mindful_youth/provider/product_provider/product_provider.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
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
import 'order_list_screen.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> with NavigateHelper {
  @override
  void initState() {
    super.initState();
    ProductProvider productProvider = context.read<ProductProvider>();
    Future.microtask(() {
      productProvider.getProductList(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.products,
          style: TextStyleHelper.mediumHeading,
        ),
        actions: [
          IconButton(
            onPressed:
                () => push(
                  context: context,
                  widget: OrderListPage(),
                  transition: FadeUpwardsPageTransitionsBuilder(),
                ),
            icon: Icon(Icons.list_alt, color: AppColors.primary),
          ),
        ],
      ),
      body: SafeArea(
        child:
            productProvider.isLoading
                ? Center(child: CustomLoader())
                : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: CustomRefreshIndicator(
                    onRefresh:
                        () async => await productProvider.getProductList(
                          context: context,
                        ),
                    child:
                        productProvider
                                    .productModel
                                    ?.data
                                    ?.product
                                    ?.isNotEmpty ==
                                true
                            ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 0.7,
                                  ),
                              itemCount:
                                  productProvider
                                      .productModel
                                      ?.data
                                      ?.product
                                      ?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                Product? product =
                                    productProvider
                                        .productModel
                                        ?.data
                                        ?.product?[index];
                                return ProductCard(product: product);
                              },
                            )
                            : ListView(
                              children: [
                                Center(
                                  child: CustomContainer(
                                    margin: EdgeInsets.only(top: 35.h),
                                    child: NoDataFoundIcon(
                                      icon: AppImageStrings.noProductFound,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget with NavigateHelper {
  const ProductCard({super.key, required this.product});
  final Product? product;
  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch<ProductProvider>();
    return GestureDetector(
      onTap: () {
        productProvider.setOrder = CreateOrderModel(
          price: product?.price,
          qty: 1,
        );
        push(
          context: context,
          widget: ProductPage(product: product),
          transition: FadeUpwardsPageTransitionsBuilder(),
        );
      },
      child: CustomContainer(
        width: 40.w,
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
        borderRadius: BorderRadius.circular(AppSize.size10),
        borderColor: AppColors.grey,
        borderWidth: 0.3,
        backGroundColor: AppColors.lightWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                child: CustomImageWithLoader(
                  showImageInPanel: false,
                  imageUrl: "${AppStrings.assetsUrl}${product?.thumbnail}",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSize.size10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: product?.title ?? "",
                    style: TextStyleHelper.mediumHeading,
                  ),
                  CustomText(
                    text: '${AppStrings.rupee} ${product?.price}',
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
  }
}
