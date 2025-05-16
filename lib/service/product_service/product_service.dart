import 'dart:developer';
// import 'package:flutter/material.dart';
import 'package:mindful_youth/models/product_model/confirm_order_model.dart';
import 'package:mindful_youth/models/product_model/create_order_model.dart';
import 'package:mindful_youth/models/product_model/product_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class ProductService {
  Future<ProductModel?> getProductList(
    // {required BuildContext context}
    ) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        // context: context,
        uri: ApiHelper.getProducts,
      );
      if (response.isNotEmpty) {
        ProductModel model = ProductModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      log('error while getting products => $e');
      return null;
    }
  }

  Future<ConfirmOrderModel?> createOrder({
    // required BuildContext context,
    required CreateOrderModel? order,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        // context: context,
        uri: ApiHelper.createOrder,
        body: {
          "orderDate": order?.orderDate,
          "product_id": order?.productId.toString(),
          "price": order?.price,
          "qty": order?.qty.toString(),
          "shipping_address": order?.shippingAddress,
          "payment_mode": order?.paymentMode,
          "transaction_id": order?.transactionId,
        },
      );
      if (response.isNotEmpty) {
        return ConfirmOrderModel.fromJson(response);
      }
      return null;
    } catch (e) {
      log('error while create order => $e');
      return null;
    }
  }
}
