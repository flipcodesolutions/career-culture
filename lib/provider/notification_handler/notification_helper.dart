import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:provider/provider.dart';
import '../../app_const/app_strings.dart';
import '../../screens/main_screen/main_screen.dart';
import '../../screens/on_boarding_screen/on_boarding_screen.dart';
import '../../screens/wall_screen/individual_wall_post_screen.dart';
import '../../utils/method_helpers/method_helper.dart';
import '../../utils/shared_prefs_helper/shared_prefs_helper.dart';
import '../user_provider/user_provider.dart';

class NotificationHelper extends ChangeNotifier with NavigateHelper {
  /// if provider is Loading
  ///

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> handleInitialDeepLink({required BuildContext context}) async {
    final appLinks = AppLinks();
    final Uri? initialUri = await appLinks.getInitialLink();

    if (initialUri != null) {
      handleDeepLink(initialUri, context: context);
      return;
    } else {
      await handleAuthAndNavigate(isFromLink: false, context: context);
    }

    appLinks.uriLinkStream.listen(
      (event) {
        handleDeepLink(event, context: context);
      },
      onError: (err) {
        handleAuthAndNavigate(isFromLink: false, context: context);
      },
    );
  }

  Future<void> handleAuthAndNavigate({
    required BuildContext context,
    required bool isFromLink,
    String? slug,
  }) async {
    final userProvider = context.read<UserProvider>();
    final token = await SharedPrefs.getToken();
    final status = await SharedPrefs.getSharedString(AppStrings.status);

    if (token.isNotEmpty) {
      userProvider.setIsUserLoggedIn = true;

      if (status != "active") {
        MethodHelper().redirectDeletedOrInActiveUserToLoginPage(
          context: context,
        );
        return;
      }

      pushRemoveUntil(
        context: context,
        widget: MainScreen(),
        transition: FadeForwardsPageTransitionsBuilder(),
      );

      if (isFromLink && slug?.isNotEmpty == true) {
        push(
          context: context,
          widget: IndividualWallPostScreen(
            slug: slug ?? "",
            isFromWallScreen: false,
          ),
        );
      }
    } else {
      pushRemoveUntil(
        context: context,
        widget: OnBoardingScreen(),
        transition: FadeForwardsPageTransitionsBuilder(),
      );
    }
  }

  void handleDeepLink(Uri uri, {required BuildContext context}) {
    // WidgetHelper.customSnackBar(title: "Deep link: $uri");

    if (uri.pathSegments.length >= 2 && uri.pathSegments.first == 'wall') {
      final String slug = uri.pathSegments[1];
      handleAuthAndNavigate(isFromLink: true, slug: slug, context: context);
    } else {
      handleAuthAndNavigate(isFromLink: false, context: context);
    }
  }
}
