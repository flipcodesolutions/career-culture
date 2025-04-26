import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/post_models/post_model.dart';
import '../../utils/shared_prefs_helper/shared_prefs_helper.dart';

class RecentActivityProvider extends ChangeNotifier {
  RecentActivityProvider() {
    loadRecentActivity();
  }

  static const String recentActivityKey = 'RECENT_ACTIVITY';
  static const String recentPostKey = 'RECENT_POST';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PostInfo? _recentPost;
  PostInfo? get recentPost => _recentPost;

  bool isRecentActivity() {
    return _recentPost != null;
  }

  Future<void> saveRecentActivity(PostInfo? post) async {
    _isLoading = true;
    notifyListeners();
    // Save PostInfo
    if (post != null) {
      String postJson = jsonEncode(post.toJson());
      await SharedPrefs.saveString(recentPostKey, postJson);
    }

    _isLoading = false;
    notifyListeners();

    await loadRecentActivity();
  }

  Future<void> loadRecentActivity() async {
    _isLoading = true;
    notifyListeners();

    String postString = await SharedPrefs.getSharedString(recentPostKey);
    if (postString.isNotEmpty) {
      Map<String, dynamic> postJson = jsonDecode(postString);
      _recentPost = PostInfo.fromJson(postJson);
    }

    _isLoading = false;
    notifyListeners();
  }
}
