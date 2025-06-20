import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/product_provider/product_provider.dart';
import 'package:mindful_youth/screens/shop_market_screen/products_screen.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../models/product_model/product_model.dart';
import '../utils/navigation_helper/navigation_helper.dart';
import 'custom_container.dart';
import 'no_data_found.dart';

class ProductShowCase extends StatelessWidget with NavigateHelper {
  const ProductShowCase({super.key});

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch<ProductProvider>();
    return productProvider.isLoading
        ? Center(child: CustomLoader())
        : productProvider.productModel?.data?.product?.isNotEmpty == true
        ? CustomContainer(
          height: 30.h,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 3.w),
            itemCount: productProvider.productModel?.data?.product?.length ?? 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              Product? product =
                  productProvider.productModel?.data?.product?[index];
              return ProductCard(product: product);
            },
          ),
        )
        : Center(child: NoDataFoundIcon(h: 10.h));
  }
}
