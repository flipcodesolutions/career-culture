import 'package:file_picker/file_picker.dart';
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
  String? answer;
  String? userAnswer;
  List<String>? extractedOptions;
  List<String>? correctAnswer;
  List<PlatformFile>? selectedFiles;
  UserAnswers? userAnswers;
  AssessmentQuestion({
    this.id,
    this.postId,
    this.question,
    this.type,
    this.options,
    this.status,
    this.answer,
    this.userAnswer,
    this.extractedOptions,
    this.correctAnswer,
    this.selectedFiles,
    this.userAnswers,
  });

  AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    question = json['question'];
    type = json['type'];
    options = json['options'];
    status = json['status'];
    correctAnswer = MethodHelper.parseOptions(json['answers']);
    extractedOptions = MethodHelper.parseOptions(json['options']);
    if (json['user_answers'] != null) {
      userAnswers = UserAnswers.fromJson(json['user_answers']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['postId'] = this.postId;
    data['question'] = this.question;
    data['type'] = this.type;
    data['options'] = this.options;
    data['status'] = this.status;
    data['answer'] = this.answer;
    data['extractedOptions'] = this.extractedOptions;
    return data;
  }

  void setPreviouslyAnswerToCurrentModel() {
    userAnswer = userAnswers?.answer;
  }
}

class UserAnswers {
  int? id;
  int? questionId;
  int? userId;
  String? answer;
  String? createdAt;
  String? updatedAt;

  UserAnswers({
    this.id,
    this.questionId,
    this.userId,
    this.answer,
    this.createdAt,
    this.updatedAt,
  });

  UserAnswers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    userId = json['user_id'];
    answer = json['answer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_id'] = this.questionId;
    data['user_id'] = this.userId;
    data['answer'] = this.answer;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
