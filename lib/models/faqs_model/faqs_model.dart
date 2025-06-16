class FAQsModel {
  String? status;
  String? message;
  List<FAQsModelData>? data;

  FAQsModel({this.status, this.message, this.data});

  FAQsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FAQsModelData>[];
      json['data'].forEach((v) {
        data!.add(new FAQsModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FAQsModelData {
  int? id;
  String? question;
  String? answer;
  String? status;
  bool isOpen = false;
  FAQsModelData({
    this.id,
    this.question,
    this.answer,
    this.status,
    this.isOpen = false,
  });

  FAQsModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['status'] = this.status;
    return data;
  }
}
