import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindful_youth/models/product_model/order_list_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class OrdersListService {
  Future<OrderListModel?> getOrderList({required BuildContext context}) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.orderList,
      );
      if (response.isNotEmpty) {
        return OrderListModel.fromJson(response);
      }
      return null;
    } catch (e) {
      log('error while getting orders list => $e');
      return null;
    }
  }
}
