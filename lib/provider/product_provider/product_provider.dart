import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindful_youth/models/product_model/confirm_order_model.dart';
import 'package:mindful_youth/models/product_model/create_order_model.dart';
import 'package:mindful_youth/models/product_model/order_list_model.dart';
import 'package:mindful_youth/service/product_service/orders_list_service.dart';
import 'package:mindful_youth/service/product_service/product_service.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import '../../app_const/app_strings.dart';
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

  /// get product image list
  List<String> getListImage({required Product? product}) {
    return [
      product?.thumbnail,
      product?.image1,
      product?.image2,
    ].where((e) => e?.isNotEmpty == true && e != null).cast<String>().toList();
  }

  /// create order
  TextEditingController addressController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CreateOrderModel? _orderModel;
  CreateOrderModel? get orderModel => _orderModel;
  set setOrder(CreateOrderModel order) {
    _orderModel = order;
    notifyListeners();
    getAddressFromLocalStorage();
  }

  void getAddressFromLocalStorage() async {
    String line1 = await SharedPrefs.getSharedString(AppStrings.addressLine1);
    String line2 = await SharedPrefs.getSharedString(AppStrings.addressLine2);
    addressController.text = "$line1 $line2";
    notifyListeners();
  }

  ConfirmOrderModel? _confirmOrderModel;
  ConfirmOrderModel? get confirmOrderModel => _confirmOrderModel;
  Future<bool> order({
    required BuildContext context,
    required Product? product,
    required int qty,
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
      qty: qty,
      shippingAddress: addressController.text,
      transactionId: DateTime.now().toIso8601String(),
    );
    _confirmOrderModel = await productService.createOrder(
      context: context,
      order: _orderModel,
    );
    if (_confirmOrderModel?.success == "success") {
      addressController.clear();
      _orderModel?.price = product?.price;
      _orderModel?.qty = 1;
      WidgetHelper.customSnackBar(title: AppStrings.orderPlaced);
    }

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
    return _confirmOrderModel?.success == "success";
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

  //// order lists
  /// Service and getter and setter
  OrdersListService ordersListService = OrdersListService();
  OrderListModel? _orderListModel;
  OrderListModel? get orderListModel => _orderListModel;

  Future<void> getOrderList({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _orderListModel = await ordersListService.getOrderList(context: context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }
}
