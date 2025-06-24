// Page
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/product_provider/product_provider.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../../models/product_model/order_list_model.dart';
import '../../widgets/custom_text.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  @override
  void initState() {
    super.initState();
    ProductProvider productProvider = context.read<ProductProvider>();
    Future.microtask(() async {
      await productProvider.getOrderList(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.myOrders,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body:
          productProvider.isLoading
              ? Center(child: CustomLoader())
              : productProvider.orderListModel?.data?.orders?.isNotEmpty == true
              ? ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount:
                    productProvider.orderListModel?.data?.orders?.length ?? 0,
                itemBuilder: (context, index) {
                  final Orders? order =
                      productProvider.orderListModel?.data?.orders?[index];
                  return OrderCard(order: order);
                },
              )
              : CustomRefreshIndicator(
                onRefresh:
                    () async => productProvider.getOrderList(context: context),
                child: ListView(
                  children: [
                    CustomContainer(
                      height: 90.h,
                      child: Center(
                        child: CustomContainer(
                          child: NoDataFoundIcon(
                            icon: AppImageStrings.noProductFound,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Orders? order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      borderColor: AppColors.grey,
      borderWidth: 0.3,
      backGroundColor: AppColors.white,
      boxShadow: ShadowHelper.scoreContainer,
      borderRadius: BorderRadius.circular(AppSize.size10),
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Order Date & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Order: ${order?.orderDate ?? "-"}',
                  style: TextStyleHelper.smallHeading,
                ),
                _StatusBadge(status: order?.status ?? ""),
              ],
            ),
            SizeHelper.height(),
            // Product Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.size10),
                  child: CustomImageWithLoader(
                    width: 20.w,
                    height: 10.h,
                    fit: BoxFit.contain,
                    imageUrl:
                        "${AppStrings.assetsUrl}${order?.product?.thumbnail}",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: order?.product?.title ?? "",
                        style: TextStyleHelper.smallHeading.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: 'Qty: ${order?.qty}',
                        style: TextStyleHelper.smallText.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: 'Price: ${AppStrings.rupee}${order?.price}',
                        style: TextStyleHelper.smallText.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 2.h),
            // Shipping & Payment
            CustomText(
              text: 'Shipping: ${order?.shippingAddress}',
              style: TextStyleHelper.smallText,
            ),
            SizeHelper.height(height: 1.h),
            CustomText(
              text: 'Payment: ${order?.paymentMode} (${order?.paymentStatus})',
              style: TextStyleHelper.smallText,
            ),
            SizeHelper.height(height: 1.h),
            CustomText(
              text: 'Transaction ID: ${order?.transactionId}',
              style: TextStyleHelper.smallText,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color _colorForStatus() {
    switch (status.toLowerCase()) {
      case 'placed':
        return AppColors.black;
      case 'confirmed':
        return AppColors.lightPrimary;
      case 'delivered':
        return AppColors.primary;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _colorForStatus().withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _colorForStatus(),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
