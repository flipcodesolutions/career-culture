class WallListModel {
  bool? success;
  String? message;
  List<WallListModelData>? data;

  WallListModel({this.success, this.message, this.data});

  WallListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WallListModelData>[];
      json['data'].forEach((v) {
        data!.add(new WallListModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WallListModelData {
  int? id;
  String? title;
  String? description;
  String? slug;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? likeCount;
  bool? isMyFavourite;

  WallListModelData({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.likeCount,
    this.isMyFavourite,
  });

  WallListModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    likeCount = json['likeCount'];
    isMyFavourite = json['isMyFavourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['likeCount'] = this.likeCount;
    data['isMyFavourite'] = this.isMyFavourite;
    return data;
  }
}
