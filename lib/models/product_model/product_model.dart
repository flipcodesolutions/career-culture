class ProductModel {
  String? status;
  String? message;
  ProductModelData? data;

  ProductModel({this.status, this.message, this.data});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null
            ? new ProductModelData.fromJson(json['data'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProductModelData {
  List<Product>? product;

  ProductModelData({this.product});

  ProductModelData.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? id;
  String? title;
  String? price;
  String? phone;
  String? url;
  String? description;
  String? image1;
  String? image2;
  String? thumbnail;

  Product({
    this.id,
    this.title,
    this.price,
    this.phone,
    this.url,
    this.description,
    this.image1,
    this.image2,
    this.thumbnail,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    phone = json['phone'];
    url = json['url'];
    description = json['description'];
    image1 = json['image1'];
    image2 = json['image2'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['phone'] = this.phone;
    data['url'] = this.url;
    data['description'] = this.description;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
