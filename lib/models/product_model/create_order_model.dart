class CreateOrderModel {
  String? orderDate;
  int? productId;
  String? price;
  int? qty;
  String? shippingAddress;
  String? paymentMode;
  String? transactionId;

  CreateOrderModel({
    this.orderDate,
    this.productId,
    this.price,
    this.qty,
    this.shippingAddress,
    this.paymentMode,
    this.transactionId,
  });

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    orderDate = json['orderDate'];
    productId = json['product_id'];
    price = json['price'];
    qty = json['qty'];
    shippingAddress = json['shipping_address'];
    paymentMode = json['payment_mode'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderDate'] = this.orderDate;
    data['product_id'] = this.productId;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['shipping_address'] = this.shippingAddress;
    data['payment_mode'] = this.paymentMode;
    data['transaction_id'] = this.transactionId;
    return data;
  }
}
