import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/notification_util/notification_util.dart';
import '../../screens/wall_screen/individual_wall_post_screen.dart';
import '../../utils/shared_prefs_helper/shared_prefs_helper.dart';

class NotificationHelper extends ChangeNotifier with NavigateHelper {
  /// if provider is Loading
  ///
  final _appLinks = AppLinks();
  StreamSubscription<Uri?>? _sub;
  Uri? _pendingUri;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// init deeplink and if uri is present store it for letter use
  Future<void> init() async {
    final Uri? uri = await _appLinks.getInitialLink();
    if (uri != null) {
      /// store it in pending uri
      _pendingUri = uri;
    }
  }

  Future<void> processInitialUri() async {
    /// get fresh token
    final String token = await SharedPrefs.getToken();
    // Listen if app is resumed from background
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && token.isNotEmpty) {
        _pendingUri = uri;
        _navigate(_pendingUri!);
      }
    });
  }

  void _navigate(Uri uri) {
    final BuildContext? context =
        NotificationService.instance.navigatorKey.currentContext;
    final List<String> segments = uri.pathSegments;

    if (segments.isEmpty) {
      return;
    }
    if (uri.pathSegments.length >= 2) {
      final String segment = uri.pathSegments.first.trim().toLowerCase();
      final String slug = uri.pathSegments[1];
      if (context != null) {
        if (segment == 'wall') {
          push(
            context: context,
            widget: IndividualWallPostScreen(
              slug: slug,
              isFromWallScreen: false,
            ),
          );
        }

        /// add other routes to navigate with slug
      }
    }
  }

  // Future<void> handleInitialDeepLink({required BuildContext context}) async {
  //   if (_pendingUri != null) {
  //     handleDeepLink(_pendingUri);
  //     return;
  //   } else {
  //     await handleAuthAndNavigate(isFromLink: false);
  //   }

  //   _appLinks.uriLinkStream.listen(
  //     (event) {
  //       handleDeepLink(event);
  //     },
  //     onError: (err) {
  //       handleAuthAndNavigate(isFromLink: false);
  //     },
  //   );
  // }

  // void handleDeepLink(Uri uri) {
  //   // WidgetHelper.customSnackBar(title: "Deep link: $uri");

  //   if (uri.pathSegments.length >= 2 && uri.pathSegments.first == 'wall') {
  //     final String slug = uri.pathSegments[1];
  //     handleAuthAndNavigate(isFromLink: true, slug: slug);
  //   } else {
  //     handleAuthAndNavigate(isFromLink: false);
  //   }
  // }
}
