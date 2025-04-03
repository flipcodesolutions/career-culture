// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:fruit_fusion_veggies_delight/app_const/app_colors.dart';
// import 'package:fruit_fusion_veggies_delight/app_const/app_size.dart';
// import 'package:fruit_fusion_veggies_delight/models/payment_model/confirmed_order_model.dart';
// import 'package:fruit_fusion_veggies_delight/models/payment_model/create_order_model.dart';
// import 'package:fruit_fusion_veggies_delight/providers/address_provider/address_provider.dart';
// import 'package:fruit_fusion_veggies_delight/providers/home_screen_provider/home_screen_provider.dart';
// import 'package:fruit_fusion_veggies_delight/providers/localization_provider/localization_provider.dart';
// import 'package:fruit_fusion_veggies_delight/screens/address.dart';
// import 'package:fruit_fusion_veggies_delight/screens/login.dart';
// import 'package:fruit_fusion_veggies_delight/utils/list_helper/list_helper.dart';
// import 'package:fruit_fusion_veggies_delight/utils/method_helpers/google_login_helper.dart';
// import 'package:fruit_fusion_veggies_delight/utils/method_helpers/size_helper.dart';
// import 'package:fruit_fusion_veggies_delight/utils/navigation_helper/navigation_helper.dart';
// import 'package:fruit_fusion_veggies_delight/utils/shared_prefs_helper/shared_prefs_helper.dart';
// import 'package:fruit_fusion_veggies_delight/utils/text_helpers/text_style_helper.dart';
// import 'package:fruit_fusion_veggies_delight/utils/widget_helper/widget_helper.dart';
// import 'package:fruit_fusion_veggies_delight/widgets/custom_container.dart';
// import 'package:fruit_fusion_veggies_delight/widgets/custom_text.dart';
// import 'package:fruit_fusion_veggies_delight/widgets/cutom_loader.dart';
// import 'package:fruit_fusion_veggies_delight/widgets/primary_btn.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import '../../app_const/app_strings.dart';
// import '../../models/address_model/address_model.dart';
// import '../../providers/cart_providder/cart_provider.dart';
// import '../../providers/point_per_provider/point_per_provider.dart';
// import '../../screens/add_to_cart.dart';
// import '../../services/order_service/order_service.dart';
// import '../../widgets/slideable_confirmation.dart';

// class MethodHelper {
//   /// will help select and change current language
//   static Future<dynamic> changeLangDialog(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: CustomContainer(
//           padding: EdgeInsets.all(AppSize.size20),
//           child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: ListHelper.languages.length,
//             itemBuilder: (context, index) {
//               String lan = ListHelper.languages[index];
//               return ListTile(
//                 splashColor: AppColors.primaryLightColor,
//                 selected: context.read<LocalizationProvider>().currentLocale ==
//                     ListHelper.languagesCode[index],
//                 selectedColor: AppColors.whiteColor,
//                 selectedTileColor: AppColors.primaryColor,
//                 title: CustomText(
//                   text: lan,
//                   style: TextStyleHelper.smallHeading,
//                 ),
//                 onTap: () =>
//                     Navigator.pop(context, ListHelper.languagesCode[index]),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   /// this method help shape app bar
//   static RoundedRectangleBorder appBarShapeCurve() {
//     return RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(5.w),
//             bottomRight: Radius.circular(5.w)));
//   }

//   /// Ask user to confirm before logout
//   static Future<dynamic> logoutDialogBox(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: AppColors.whiteColor,
//         title: CustomLocaleText(
//           text: 'logout?',
//           style: TextStyleHelper.largeHeading,
//         ),
//         content: CustomLocaleText(
//           useOverflow: false,
//           text: 'wantToLogout',
//           style: TextStyleHelper.mediumText,
//         ),
//         actionsOverflowDirection: VerticalDirection.down,
//         actions: [
//           /// for cancel
//           PrimaryBtn(
//             height: 5.h,
//             textStyle: TextStyleHelper.smallText
//                 .copyWith(color: AppColors.primaryColor),
//             backGroundColor: AppColors.whiteColor,
//             btnText: translateLocale(key: 'cancel', context: context),
//             onTap: () => Navigator.of(context).pop(),
//           ),
//           SizeHelper.height(),

//           /// for logout
//           PrimaryBtn(
//             height: 5.h,
//             borderColor: AppColors.errorColor,
//             backGroundColor: AppColors.errorColor,
//             textStyle:
//                 TextStyleHelper.smallText.copyWith(color: AppColors.whiteColor),
//             btnText: translateLocale(key: 'logout', context: context),
//             onTap: () async => {
//               await SharedPrefs.clearShared(),
//               await GoogleLoginHelper.signOut(),
//               if (context.mounted)
//                 {
//                   context.read<HomeScreenProvider>().setNavigationIndex = 0,
//                   Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                       builder: (context) => LoginPage(),
//                     ),
//                     (route) => false,
//                   )
//                 }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   /// get locale translated string
//   static String translateLocale(
//       {required String key, required BuildContext context}) {
//     return context.read<LocalizationProvider>().translate(key);
//   }

//   // Debounce function to prevent multiple API calls
//   static void Function() debounce(VoidCallback action,
//       {int milliseconds = 500}) {
//     Timer? _timer;

//     return () {
//       // Cancel any previous timer if it exists
//       if (_timer?.isActive ?? false) {
//         _timer?.cancel();
//       }

//       // Start a new timer with a delay
//       _timer = Timer(Duration(milliseconds: milliseconds), action);
//     };
//   }

//   static void showExitConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             // side: BorderSide(color: AppColors.primaryColor, width: 4)
//           ),
//           backgroundColor: Colors.transparent,
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               CustomContainer(
//                 padding: EdgeInsets.all(20),
//                 backGroundColor: AppColors.whiteColor,
//                 borderRadius: BorderRadius.circular(AppSize.size10),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CustomLocaleText(
//                         text: AppStrings.doYouWantToexit,
//                         style: TextStyleHelper.mediumHeading),
//                     SizeHelper.height(),
//                     // Animated Exit Icon
//                     Icon(
//                       Icons.exit_to_app_rounded,
//                       color: Colors.redAccent,
//                       size: 40,
//                     )
//                         .animate(onPlay: (controller) => controller.repeat())
//                         .shake(duration: 800.ms, hz: 4, curve: Curves.easeOut),

//                     SizeHelper.height(height: 3.h),

//                     // Action Buttons
//                     SingleChildScrollView(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           //SizeHelper.height(),
//                           // SizeHelper.width(),
//                           PrimaryBtn(
//                               height: 5.h,
//                               width: 20.w,
//                               btnText: context
//                                   .read<LocalizationProvider>()
//                                   .translate(AppStrings.cancel),
//                               onTap: () => Navigator.of(dialogContext).pop()),
//                           PrimaryBtn(
//                               backGroundColor: AppColors.errorColor,
//                               borderColor: AppColors.errorColor,
//                               textStyle: TextStyleHelper.smallHeading
//                                   .copyWith(color: AppColors.whiteColor),
//                               height: 5.h,
//                               width: 20.w,
//                               btnText: context
//                                   .read<LocalizationProvider>()
//                                   .translate(AppStrings.exit),
//                               onTap: () {
//                                 Navigator.of(dialogContext)
//                                     .pop(); // Close dialog
//                                 Future.delayed(Duration(milliseconds: 300), () {
//                                   // Exit the app
//                                   Navigator.of(context).pop(true);
//                                 });
//                               }),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   /// Generates star icons with color changing based on rating.
//   static List<Widget> buildRatingStars({
//     required int rating,
//     double size = 18,
//   }) {
//     Color starColor = getStarColor(rating);

//     return List.generate(5, (index) {
//       return Icon(
//         index < rating ? Icons.star : Icons.star_border,
//         color: index < rating ? starColor : Colors.grey,
//         size: size,
//       );
//     });
//   }

//   /// Returns star color based on the rating value.
//   static Color getStarColor(int rating) {
//     if (rating <= 2) {
//       return AppColors.errorColor;
//     } else if (rating == 3) {
//       return AppColors.orange;
//     } else if (rating >= 4) {
//       return AppColors.primaryColor;
//     } else {
//       return AppColors.primaryColor;
//     }
//   }

//   /// Formats ISO string to '28 Jan 2025 9:26 pm'
//   static String formatDate(String dateString) {
//     DateTime dateTime = DateTime.parse(dateString);
//     String formattedDate = DateFormat('d MMM yyyy h:mm a').format(dateTime);
//     return formattedDate;
//   }

//   ///
//   ///
//   static Future<dynamic> purchaseSummaryBottomSheet({
//     required BuildContext context,
//     required String subTotal,
//     String? deliveryType,
//     String? deliverySlot,
//     required int? pointPer,
//     required double discountedTotal,
//     required List<OrderDetails>? orderDetails,
//   }) async {
//     LocalizationProvider langProvider = context.read<LocalizationProvider>();
//     AddressProvider addressProvider = context.read<AddressProvider>();
//     final service = OrderService();

//     bool isLoading = false;
//     bool doingPayment = false;
//     String paymentMode = "cash";

//     // Check for Address before opening bottom sheet
//     if (addressProvider.selectedAddress == null) {
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AddressScreen(isFromBillSummary: true),
//         ),
//       );
//     }

//     return showModalBottomSheet(
//       backgroundColor: AppColors.whiteColor,
//       enableDrag: true,
//       showDragHandle: true,
//       useSafeArea: true,
//       isScrollControlled: true,
//       sheetAnimationStyle: AnimationStyle(
//         curve: Curves.decelerate,
//         duration: Duration(milliseconds: 600),
//         reverseCurve: Curves.decelerate,
//         reverseDuration: Duration(milliseconds: 350),
//       ),
//       context: context,
//       builder: (builderContext) => StatefulBuilder(
//         builder: (context, refresh) {
//           void updatePaymentMode(String mode) {
//             refresh(() {
//               doingPayment = true;
//               paymentMode = mode;
//             });
//           }

//           return CustomContainer(
//             padding: EdgeInsets.symmetric(
//                 horizontal: AppSize.size20, vertical: AppSize.size10),
//             borderRadius:
//                 BorderRadius.vertical(top: Radius.circular(AppSize.size10)),
//             border: Border(
//                 top: BorderSide(color: AppColors.primaryColor, width: 2)),
//             child: SingleChildScrollView(
//               padding: EdgeInsets.only(bottom: AppSize.size20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Change Address Button
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: PrimaryBtn(
//                       width: 20.w,
//                       height: 4.h,
//                       backGroundColor: AppColors.whiteColor,
//                       textStyle: TextStyleHelper.smallText
//                           .copyWith(color: AppColors.primaryColor),
//                       btnText: langProvider.translate(AppStrings.change),
//                       onTap: () async {
//                         final success = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 AddressScreen(isFromBillSummary: true),
//                           ),
//                         );
//                         if (success != null) refresh(() {});
//                       },
//                     ),
//                   ),

//                   /// Order Summary
//                   InvoiceInfoRow(
//                     label: langProvider.translate(AppStrings.address),
//                     value: addressProvider.selectedAddress?.fullAddress() ?? '',
//                   ),
//                   InvoiceInfoRow(
//                     label: AppStrings.subTotal,
//                     value: '${AppStrings.rupee} $subTotal',
//                   ),
//                   InvoiceInfoRow(
//                     label: AppStrings.delivery,
//                     value:
//                         deliveryType ?? langProvider.translate(AppStrings.free),
//                   ),
//                   InvoiceInfoRow(
//                     label: AppStrings.deliverySlots,
//                     value: deliverySlot ??
//                         langProvider.translate(AppStrings.tommorow930Am),
//                   ),
//                   InvoiceInfoRow(
//                     label:
//                         "${langProvider.translate(AppStrings.specialDiscount)} (${pointPer ?? 0}%)",
//                     value: "$discountedTotal",
//                   ),

//                   const Divider(),

//                   /// Total Amount
//                   InvoiceInfoRow(
//                     label: AppStrings.totalAmount,
//                     value: '${AppStrings.rupee} $discountedTotal',
//                     keyTextStyle: TextStyleHelper.mediumHeading,
//                     valueTextStyle: TextStyleHelper.mediumHeading,
//                   ),

//                   SizeHelper.height(),

//                   if (doingPayment)

//                     /// Swipe to Confirm Order
//                     SwipeToConfirm(
//                       text: langProvider.translate(AppStrings.slideToConfirm),
//                       onConfirm: () async {
//                         refresh(() => isLoading = true);

//                         OrderConfirmedModel? confirmedOrder =
//                             await service.createOrder(
//                           context: context,
//                           orderDetails: CreateOrderModel(
//                             order: Order(
//                               totalOrderAmt: int.tryParse(subTotal),
//                               disAmtPoint: pointPer,
//                               totalBillAmt: discountedTotal.toInt(),
//                               shippingId: addressProvider.selectedAddress?.id,
//                               deliverySlotId:
//                                   int.tryParse(AppStrings.deliverySlotId),
//                               paymentMode: paymentMode,
//                               orderDetails: orderDetails,
//                             ),
//                           ),
//                         );
//                         refresh(() {
//                           isLoading = false;
//                           doingPayment = false; // Reset payment state
//                         });

//                         if (confirmedOrder?.success == true) {
//                           Navigator.pop(context, true);
//                           await context
//                               .read<CartProvider>()
//                               .getCartProducts(context: context);
//                           WidgetHelper.customSnackBar(
//                             context: context,
//                             title: "${confirmedOrder?.message}",
//                           );
//                         } else {
//                           WidgetHelper.customSnackBar(
//                             context: context,
//                             title: langProvider
//                                 .translate(AppStrings.someThingFailed),
//                             isError: true,
//                           );
//                         }
//                       },
//                     )
//                   else if (!isLoading)

//                     /// Payment Mode Selection
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(
//                           child: PrimaryBtn(
//                             btnText: langProvider
//                                 .translate(AppStrings.cashOnDelivery),
//                             textStyle: TextStyleHelper.mediumText
//                                 .copyWith(color: AppColors.whiteColor),
//                             onTap: () => updatePaymentMode("cash"),
//                           ),
//                         ),
//                         SizeHelper.width(),
//                         Flexible(
//                           child: PrimaryBtn(
//                             btnText:
//                                 langProvider.translate(AppStrings.payOnline),
//                             textStyle: TextStyleHelper.mediumText
//                                 .copyWith(color: AppColors.whiteColor),
//                             onTap: () => updatePaymentMode("online"),
//                           ),
//                         ),
//                       ],
//                     )
//                   else
//                     Center(child: CustomLoader()),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
