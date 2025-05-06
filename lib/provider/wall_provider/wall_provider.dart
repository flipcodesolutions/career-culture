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

  Future<void> likePost({
    required BuildContext context,
    required int wallId,
  }) async {
    // 1) Call service
    final PostLikeModel? success = await _postService.likePost(
      context: context,
      wallId: wallId,
    );

    // 2) Bail out if not successful
    if (success?.success != true) return;

    List<WallListModelData>? list = _wallModel?.data;
    if (list == null) return;

    // 3) Find the index
    final int idx = list.indexWhere((e) => e.id == wallId);
    if (idx < 0) return;

    // 4) Update in-place
    final WallListModelData item = list[idx];
    final bool wasFav = item.isMyFavourite ?? false;

    item
      ..isMyFavourite = !wasFav
      ..likeCount = (item.likeCount ?? 0) + (wasFav ? -1 : 1);

    // 5) Notify once
    notifyListeners();
  }
}
