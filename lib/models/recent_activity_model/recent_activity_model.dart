///
class RecentActivityModel {
  String? imageUrl;
  String? chapter;
  String? description;
  int? progressPercent;

  RecentActivityModel({
    this.imageUrl,
    this.chapter,
    this.description,
    this.progressPercent,
  });

  RecentActivityModel.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    chapter = json['chapter'];
    description = json['description'];
    progressPercent = json['progressPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['chapter'] = this.chapter;
    data['description'] = this.description;
    data['progressPercent'] = this.progressPercent;
    return data;
  }
}
