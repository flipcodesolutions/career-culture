import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/product_model/product_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class ProductService {
  Future<ProductModel?> getProductList({required BuildContext context}) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
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
}
