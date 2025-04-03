import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String tokenKey = 'CAREERCULTURETOKEN';

  /// ================================================
  // for clear shared preferences
  static Future<bool> clearShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  /// ==============================================================

  // for save token
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // to get token
  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? '';
  }

  // clear token
  static Future<bool> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(tokenKey);
  }

  /// ==============================================================
  // business name
  static Future<void> saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // to get token
  static Future<String> getSharedString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(key) ?? '';
  }

  static Future<void> removeSharedString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

//  static const String Key = "KEY";
//   static Future<void> saveAddressId(type) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(key, typeValue);
//   }

//   // to get lang
//   static Future<int> getAddress() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key) ?? "";
//   }

//   // clear lang
//   static Future<bool> clearAddress() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return await prefs.remove(key);
//   }
