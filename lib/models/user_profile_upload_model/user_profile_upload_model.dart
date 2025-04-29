class UserProfileUploadModel {
  bool? success;
  String? message;
  UserProfileUploadModelData? data;

  UserProfileUploadModel({this.success, this.message, this.data});

  UserProfileUploadModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new UserProfileUploadModelData.fromJson(json['data'])
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

class UserProfileUploadModelData {
  String? imagePath;

  UserProfileUploadModelData({this.imagePath});

  UserProfileUploadModelData.fromJson(Map<String, dynamic> json) {
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_path'] = this.imagePath;
    return data;
  }
}
