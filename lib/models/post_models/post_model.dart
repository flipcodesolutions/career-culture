import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';

import '../../app_const/app_strings.dart';

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
  String? isOnWall;
  int? points;
  String? status;
  List<Media>? media;
  bool? isForVideo;
  bool? isForImage;
  bool? isAssessmentDone;
  String? assessmentStatus;
  PostInfo({
    this.id,
    this.chapterId,
    this.title,
    this.description,
    this.image,
    this.video,
    this.audio,
    this.isAnnouncement,
    this.isOnWall,
    this.points,
    this.status,
    this.media,
    this.isForImage,
    this.isForVideo,
    this.isAssessmentDone,
    this.assessmentStatus,
  });

  PostInfo copyWith({
    String? image,
    String? video,
    int? id,
    int? chapterId,
    String? title,
    String? description,
    String? audio,
    String? isAnnouncement,
    String? isOnWall,
    int? points,
    String? status,
    List<Media>? media,
    bool? isForImage,
    bool? isForVideo,
    bool? isAssessmentDone,
    String? assessmentStatus,
  }) {
    return PostInfo(
      id: id ?? this.id,
      chapterId: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      audio: audio ?? this.audio,
      isAnnouncement: isAnnouncement ?? this.isAnnouncement,
      isOnWall: isOnWall ?? this.isOnWall,
      points: points ?? this.points,
      status: status ?? this.status,
      media: media ?? this.media,
      image: image ?? this.image,
      video: video ?? this.video,
      isForImage: isForImage ?? this.isForImage,
      isForVideo: isForVideo ?? this.isForVideo,
      isAssessmentDone: isAssessmentDone ?? this.isAssessmentDone,
      assessmentStatus: assessmentStatus ?? this.assessmentStatus,
    );
  }

  PostInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chapterId = json['chapter_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    video = json['video'];
    audio = json['audio'];
    isAnnouncement = json['isAnnouncement'];
    isAnnouncement = json['isOnWall'];
    points = int.tryParse(json['points'].toString()) ?? 0;
    status = json['status'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    isAssessmentDone = json['assessment'];
    assessmentStatus = json['assessmentStatus'];
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
    data['points'] = this.isAnnouncement;
    data['isOnWall'] = this.isOnWall;
    data['status'] = this.status;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['assessment'] = isAssessmentDone;
    data['assessmentStatus'] = assessmentStatus;
    return data;
  }

  void handleWhatToShowIfAssessmentHasSubmittedAlready() {
    if (assessmentStatus == null) {
      WidgetHelper.customSnackBar(
        title: AppStrings.somethingWentWrong,
        isError: true,
      );
    } else {
      assessmentStatus?.toLowerCase() == "Approved".toLowerCase()
          ? WidgetHelper.customSnackBar(
            title: AppStrings.yourAssessmentIsDoneAlready,
          )
          : WidgetHelper.customSnackBar(
            title: AppStrings.yourAssessmentIsUnderReview,
            isError: true,
          );
    }
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
