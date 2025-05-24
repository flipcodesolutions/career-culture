import 'package:flutter/widgets.dart';
import 'package:mindful_youth/models/post_models/post_like_model.dart';
import 'package:mindful_youth/screens/wall_screen/individual_wall_post_screen.dart';
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
  Future<void> getWall(
    // {required BuildContext context}
  ) async {
    _isLoading = true;
    notifyListeners();

    // try {
    _wallModel = await _postService.getWallPosts();
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
    required int wallId,
    required bool isFromWallScreen,
  }) async {
    // 1. Call the service
    final PostLikeModel? response = await _postService.likePost(wallId: wallId);
    if (response?.success != true) return;

    // 2. Update the wall list item
    final list = _wallModel?.data;
    final index = list?.indexWhere((e) => e.id == wallId) ?? -1;
    if (index >= 0 && list != null) {
      _toggleLike(list[index]);
    }

    // // 3. Update the slug post if it's the same post
    if (_slugWallPost?.id == wallId && !isFromWallScreen) {
      _toggleLike(_slugWallPost);
    }

    // 4. Notify UI
    notifyListeners();
  }

  /// Helper to toggle like state and count
  void _toggleLike(WallListModelData? post) {
    final wasFav = post?.isMyFavourite ?? false;
    post
      ?..isMyFavourite = !wasFav
      ..likeCount = (post.likeCount ?? 0) + (wasFav ? -1 : 1);
  }

  /// get the slug from launch so it can be passed to backend and get the post data to create [IndividualWallPostScreen]
  /// will use the instance of [WallListModelData]
  WallListModelData? _slugWallPost;
  WallListModelData? get slugWallPost => _slugWallPost;
  void initWallPostSlugFromWallScreen({required WallListModelData? post}) {
    _slugWallPost = post;
  }

  Future<void> getWallPostBySlug({required String? slug}) async {
    /// if slug
    if (slug?.isNotEmpty == true && slug != null) {
      /// set _isLoading true
      _isLoading = true;
      notifyListeners();
      _slugWallPost = await _postService.getWallPostBySlug(slug: slug);

      /// set _isLoading false
      _isLoading = false;
      notifyListeners();
    }
  }
}
