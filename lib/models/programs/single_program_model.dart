import 'package:mindful_youth/models/programs/programs_model.dart';

class SingleProgramModel {
  bool? success;
  String? message;
  ProgramsInfo? data;

  SingleProgramModel({this.success, this.message, this.data});

  SingleProgramModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? new ProgramsInfo.fromJson(json['data']) : null;
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
