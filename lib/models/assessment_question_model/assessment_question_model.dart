import 'package:mindful_youth/utils/method_helpers/method_helper.dart';

class AssessmentQuestionModel {
  bool? success;
  String? message;
  List<AssessmentQuestion>? data;

  AssessmentQuestionModel({this.success, this.message, this.data});

  AssessmentQuestionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AssessmentQuestion>[];
      json['data'].forEach((v) {
        data!.add(new AssessmentQuestion.fromJson(v));
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

class AssessmentQuestion {
  int? id;
  int? postId;
  String? question;
  String? type;
  String? options;
  String? status;
  String? selectedOption;
  List<String>? extractedOptions;
  AssessmentQuestion({
    this.id,
    this.postId,
    this.question,
    this.type,
    this.options,
    this.status,
    this.selectedOption,
    this.extractedOptions,
  });

  AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    question = json['question'];
    type = json['type'];
    options = json['options'];
    status = json['status'];
    extractedOptions =  MethodHelper.parseOptions(json['options']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['postId'] = this.postId;
    data['question'] = this.question;
    data['type'] = this.type;
    data['options'] = this.options;
    data['status'] = this.status;
    data['answer'] = this.selectedOption;
    data['extractedOptions'] = this.extractedOptions;
    return data;
  }
}
