import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/product_provider/product_provider.dart';
import 'package:mindful_youth/screens/shop_market_screen/products_screen.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../utils/navigation_helper/navigation_helper.dart';
import 'custom_container.dart';

class ProductShowCase extends StatelessWidget with NavigateHelper {
  const ProductShowCase({super.key});

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch<ProductProvider>();
    return productProvider.isLoading
        ? Center(child: CustomLoader())
        : productProvider.productModel?.data?.product?.isNotEmpty == true
        ? CustomContainer(
          width: 40.w,
          child: CarouselSlider(
            items:
                productProvider.productModel?.data?.product?.map((image) {
                  return Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: ProductCard(product: image),
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
        )
        : Center(child: NoDataFoundWidget());
  }
}
