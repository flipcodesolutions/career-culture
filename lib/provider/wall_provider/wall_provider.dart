import 'package:flutter/widgets.dart';
import 'package:mindful_youth/models/post_models/post_like_model.dart';
import 'package:mindful_youth/service/post_service/post_service.dart';
import '../../models/post_models/wall_model.dart';

class WallProvider extends ChangeNotifier {
  /// Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Services and models
  final PostService _postService = PostService();
  WallListModel? _wallModel;
  WallListModel? get wallModel => _wallModel;

  // final List<PostInfo> _wallPost = [];
  // List<PostInfo> get wallPost => _wallPost;

  /// Fetch wall data
  Future<void> getWall({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    // try {
    _wallModel = await _postService.getWallPosts(context: context);
    // _wallPost.clear();

    // if (_wallModel?.success == true && _wallModel?.data != null) {
    //   // for (PostInfo post in _wallModel?.data ?? []) {
    //   //   if (post.video?.isNotEmpty == true) {
    //   //     _wallPost.add(post.copyWith(isForVideo: true, isForImage: false));
    //   //   }
    //   //   if (post.image?.isNotEmpty == true) {
    //   //     _wallPost.add(post.copyWith(isForImage: true, isForVideo: false));
    //   //   }
    //   // }
    // }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> likePost({
    required BuildContext context,
    required int wallId,
  }) async {
    PostLikeModel? success = await _postService.likePost(
      context: context,
      wallId: wallId,
    );
    if (success?.status == "success") {
      int? index = _wallModel?.data?.indexWhere((e) => e.id == wallId);
      if (index != -1) {
        WallListModelData? temp = _wallModel?.data?[index ?? -1];
        if (temp?.isMyFavourite == true) {
          temp?.likeCount = (temp.likeCount ?? 1) - 1;
          temp?.isMyFavourite = false;
        } else {
          temp?.likeCount = (temp.likeCount ?? 0) + 1;
          temp?.isMyFavourite = false;
        }
        _wallModel?.data?[index ?? -1] = temp!;
        notifyListeners();
      }
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }
}
