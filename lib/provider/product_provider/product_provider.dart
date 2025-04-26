import 'package:flutter/material.dart';
import 'package:mindful_youth/service/product_service/product_service.dart';

import '../../models/product_model/product_model.dart';

class ProductProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Service and getter and setter
  ProductService productService = ProductService();
  ProductModel? _productModel;
  ProductModel? get productModel => _productModel;

  Future<void> getProductList({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _productModel = await productService.getProductList(context: context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }
}
