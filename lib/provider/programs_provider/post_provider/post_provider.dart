import 'package:flutter/material.dart';
import 'package:mindful_youth/models/post_models/post_model.dart';
import 'package:mindful_youth/service/post_service/post_service.dart';

class PostProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Service and getter and setter
  PostService postService = PostService();
  PostListModel? _postListModel;
  PostListModel? get postListModel => _postListModel;

  Future<void> getPostById({
    required BuildContext context,
    required String id,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _postListModel = await postService.getPostById(context: context, id: id);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

}
