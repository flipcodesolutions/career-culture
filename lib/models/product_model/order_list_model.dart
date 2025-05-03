import 'product_model.dart';

class OrderListModel {
  bool? success;
  String? message;
  OrderListModelData? data;

  OrderListModel({this.success, this.message, this.data});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new OrderListModelData.fromJson(json['data'])
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

class OrderListModelData {
  List<Orders>? orders;

  OrderListModelData({this.orders});

  OrderListModelData.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
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
  Product? product;

  Orders({
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
    this.product,
  });

  Orders.fromJson(Map<String, dynamic> json) {
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
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
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
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

// class Product {
//   int? id;
//   String? title;
//   String? price;
//   String? description;
//   String? image1;
//   String? image2;
//   String? thumbnail;
//   String? status;

//   Product({
//     this.id,
//     this.title,
//     this.price,
//     this.description,
//     this.image1,
//     this.image2,
//     this.thumbnail,
//     this.status,
//   });

//   Product.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     price = json['price'];
//     description = json['description'];
//     image1 = json['image1'];
//     image2 = json['image2'];
//     thumbnail = json['thumbnail'];
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['price'] = this.price;
//     data['description'] = this.description;
//     data['image1'] = this.image1;
//     data['image2'] = this.image2;
//     data['thumbnail'] = this.thumbnail;
//     data['status'] = this.status;
//     return data;
//   }
// }
