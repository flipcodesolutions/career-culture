import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Service and getter and setter
  // UserServices userService = UserServices();
  // LoginModel? _loginModel;
  // LoginModel? get loginModel => _loginModel;
}
