class PostListModel {
  bool? success;
  String? message;
  List<PostInfo>? data;

  PostListModel({this.success, this.message, this.data});

  PostListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PostInfo>[];
      json['data'].forEach((v) {
        data!.add(new PostInfo.fromJson(v));
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

class PostInfo {
  int? id;
  int? chapterId;
  String? title;
  String? description;
  String? image;
  String? video;
  String? audio;
  String? isAnnouncement;
  String? status;
  List<Media>? media;

  PostInfo({
    this.id,
    this.chapterId,
    this.title,
    this.description,
    this.image,
    this.video,
    this.audio,
    this.isAnnouncement,
    this.status,
    this.media,
  });

  PostInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chapterId = json['chapter_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    video = json['video'];
    audio = json['audio'];
    isAnnouncement = json['isAnnouncement'];
    status = json['status'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chapter_id'] = this.chapterId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['video'] = this.video;
    data['audio'] = this.audio;
    data['isAnnouncement'] = this.isAnnouncement;
    data['status'] = this.status;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  int? id;
  int? postId;
  String? title;
  String? url;
  String? thumbnail;
  String? type;
  String? status;

  Media({
    this.id,
    this.postId,
    this.title,
    this.url,
    this.thumbnail,
    this.type,
    this.status,
  });

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    title = json['title'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    type = json['type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['title'] = this.title;
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    data['type'] = this.type;
    data['status'] = this.status;
    return data;
  }
}
