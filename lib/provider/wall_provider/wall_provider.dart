import 'package:flutter/widgets.dart';
import 'package:mindful_youth/models/post_models/post_model.dart';
import 'package:mindful_youth/service/post_service/post_service.dart';

class WallProvider extends ChangeNotifier {
  /// Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Services and models
  final PostService _postService = PostService();
  PostListModel? _wallModel;
  PostListModel? get wallModel => _wallModel;

  final List<PostInfo> _wallPost = [];
  List<PostInfo> get wallPost => _wallPost;

  /// Fetch wall data
  Future<void> getWall({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _wallModel = await _postService.getWallPosts(context: context);
      _wallPost.clear();

      if (_wallModel?.success == true && _wallModel?.data != null) {
        for (PostInfo post in _wallModel?.data ?? []) {
          if (post.video?.isNotEmpty == true) {
            _wallPost.add(post.copyWith(isForVideo: true, isForImage: false));
          }
          if (post.image?.isNotEmpty == true) {
            _wallPost.add(post.copyWith(isForImage: true, isForVideo: false));
          }
        }
      }
    } catch (e) {
      // Log or handle errors as needed
      debugPrint('Error fetching wall posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
