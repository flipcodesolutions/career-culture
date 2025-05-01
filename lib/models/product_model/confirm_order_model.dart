class ConfirmOrderModel {
  bool? success;
  String? message;
  ConfirmOrderModelData? data;

  ConfirmOrderModel({this.success, this.message, this.data});

  ConfirmOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new ConfirmOrderModelData.fromJson(json['data'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ConfirmOrderModelData {
  int? id;
  int? userId;
  String? orderDate;
  int? productId;
  String? price;
  int? qty;
  String? shippingAddress;
  String? status;
  String? paymentStatus;
  String? paymentMode;
  String? transactionId;

  ConfirmOrderModelData({
    this.id,
    this.userId,
    this.orderDate,
    this.productId,
    this.price,
    this.qty,
    this.shippingAddress,
    this.status,
    this.paymentStatus,
    this.paymentMode,
    this.transactionId,
  });

  ConfirmOrderModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderDate = json['orderDate'];
    productId = json['product_id'];
    price = json['price'];
    qty = json['qty'];
    shippingAddress = json['shipping_address'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    paymentMode = json['payment_mode'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['orderDate'] = this.orderDate;
    data['product_id'] = this.productId;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['shipping_address'] = this.shippingAddress;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['payment_mode'] = this.paymentMode;
    data['transaction_id'] = this.transactionId;
    return data;
  }
}
