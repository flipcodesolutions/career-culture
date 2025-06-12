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
  String? audioGuj;
  String? audioHin;
  String? isAnnouncement;
  String? isOnWall;
  int? points;
  String? status;
  List<Media>? media;
  bool? isForVideo;
  bool? isForImage;
  // bool? isAssessmentDone;
  bool? isFirstAssessmentDone;
  bool? isSecondAssessmentDone;
  PostInfo({
    this.id,
    this.chapterId,
    this.title,
    this.description,
    this.image,
    this.video,
    this.audio,
    this.audioGuj,
    this.audioHin,
    this.isAnnouncement,
    this.isOnWall,
    this.points,
    this.status,
    this.media,
    this.isForImage,
    this.isForVideo,
    // this.isAssessmentDone,
    this.isFirstAssessmentDone,
    this.isSecondAssessmentDone,
  });

  PostInfo copyWith({
    String? image,
    String? video,
    int? id,
    int? chapterId,
    String? title,
    String? description,
    String? audio,
    String? audioGuj,
    String? audioHin,
    String? isAnnouncement,
    String? isOnWall,
    int? points,
    String? status,
    List<Media>? media,
    bool? isForImage,
    bool? isForVideo,
    // bool? isAssessmentDone,
    bool? isFirstAssessmentDone,
    bool? isSecondAssessmentDone,
  }) {
    return PostInfo(
      id: id ?? this.id,
      chapterId: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      audio: audio ?? this.audio,
      audioGuj: audioGuj ?? this.audioGuj,
      audioHin: audioHin ?? this.audioHin,
      isAnnouncement: isAnnouncement ?? this.isAnnouncement,
      isOnWall: isOnWall ?? this.isOnWall,
      points: points ?? this.points,
      status: status ?? this.status,
      media: media ?? this.media,
      image: image ?? this.image,
      video: video ?? this.video,
      isForImage: isForImage ?? this.isForImage,
      isForVideo: isForVideo ?? this.isForVideo,
      // isAssessmentDone: isAssessmentDone ?? this.isAssessmentDone,
      isFirstAssessmentDone:
          isFirstAssessmentDone ?? this.isFirstAssessmentDone,
      isSecondAssessmentDone:
          isSecondAssessmentDone ?? this.isSecondAssessmentDone,
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
    audioGuj = json['audio_guj'];
    audioHin = json['audio_hin'];
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
    // isAssessmentDone = json['assessment'];
    isFirstAssessmentDone = json['firstAssessment'];
    isSecondAssessmentDone = json['secondAssessment'];
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
    data['audio_hin'] = this.audioHin;
    data['audio_guj'] = this.audioGuj;
    data['isAnnouncement'] = this.isAnnouncement;
    data['points'] = this.isAnnouncement;
    data['isOnWall'] = this.isOnWall;
    data['status'] = this.status;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    // data['assessment'] = isAssessmentDone;
    data['firstAssessment'] = isFirstAssessmentDone;
    data['secondAssessment'] = isSecondAssessmentDone;
    return data;
  }

  // void handleWhatToShowIfAssessmentHasSubmittedAlready() {
  //   if (isFirstAssessmentDone == null) {
  //     WidgetHelper.customSnackBar(
  //       title: AppStrings.somethingWentWrong,
  //       isError: true,
  //     );
  //   } else {
  //     isFirstAssessmentDone?.toLowerCase() == "Approved".toLowerCase()
  //         ? WidgetHelper.customSnackBar(
  //           title: AppStrings.yourAssessmentIsDoneAlready,
  //           autoClose: false,
  //         )
  //         : WidgetHelper.customSnackBar(
  //           title: AppStrings.yourAssessmentIsUnderReview,
  //           isError: true,
  //           autoClose: false,
  //         );
  //   }
  // }
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
