// import 'package:mindful_youth/models/login_model/user_signup_confirm_model.dart';

// class LoginResponseModel {
//   bool? success;
//   String? message;
//   UserSignUpConfirmModelData? data;

//   LoginResponseModel({this.success, this.message, this.data});

//   LoginResponseModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data =
//         json['data'] != null
//             ? new UserSignUpConfirmModelData.fromJson(json['data'])
//             : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
