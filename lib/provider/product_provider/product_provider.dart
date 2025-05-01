import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindful_youth/models/product_model/confirm_order_model.dart';
import 'package:mindful_youth/models/product_model/create_order_model.dart';
import 'package:mindful_youth/service/product_service/product_service.dart';
import '../../app_const/app_strings.dart';
import '../../models/product_model/product_model.dart';
import '../../utils/navigation_helper/navigation_helper.dart';

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

  /// create order
  TextEditingController addressController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CreateOrderModel? _orderModel;
  CreateOrderModel? get orderModel => _orderModel;
  set setOrder(CreateOrderModel order) {
    _orderModel = order;
    notifyListeners();
  }

  ConfirmOrderModel? _confirmOrderModel;
  ConfirmOrderModel? get confirmOrderModel => _confirmOrderModel;
  Future<bool> order({
    required BuildContext context,
    required Product? product,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();

    /// create order bunch
    _orderModel = CreateOrderModel(
      orderDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      paymentMode: AppStrings.cashOnDelivery,
      price: product?.price ?? "",
      productId: product?.id ?? -1,
      qty: 1,
      shippingAddress: addressController.text,
      transactionId: DateTime.now().toIso8601String(),
    );
    _confirmOrderModel = await productService.createOrder(
      context: context,
      order: _orderModel,
    );
    if (_confirmOrderModel?.success == true) {
      addressController.clear();
      _orderModel = null;
    }

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
    return _confirmOrderModel?.success ?? false;
  }

  void changeQty({required bool add, required int price}) {
    int currentQty = _orderModel?.qty ?? 1;

    if (_orderModel != null) {
      _orderModel!.qty =
          add ? currentQty + 1 : (currentQty > 1 ? currentQty - 1 : 1);
      _orderModel?.price = (price * (_orderModel?.qty ?? 1)).toString();
      notifyListeners();
    }
  }
}
