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

  PostInfo? _currentPost;
  PostInfo? get currentPost => _currentPost;
  set setPostInfo(PostInfo? post) {
    _currentPost = post;
    notifyListeners();
  }

  Future<void> getPostById({
    // required BuildContext context,
    required String id,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _postListModel = await postService.getPostById( id: id);
    if (_postListModel?.success == true && _postListModel?.data?.length == 1) {
      _currentPost = _postListModel?.data?.first;
      notifyListeners();
    }

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }
}
