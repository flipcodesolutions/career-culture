import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider/login_provider.dart';

class FacebookFirebaseLogin {
  static Future<void> loginWithFacebook(BuildContext context) async {
    try {
      await FacebookAuth.instance.logOut();

      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user == null) {
          WidgetHelper.customSnackBar(
            title: "Facebook Authentication failed",
            isError: true,
          );
          return;
        }

        if (!context.mounted) return;

        /// Call the same logic as Google to validate user from backend
        final loginProvider = context.read<LoginProvider>();
        await loginProvider.checkEmailExit(
          context: context,
          email: user.email ?? "",
        );

        /// Optional: show a snack after backend login success
        WidgetHelper.customSnackBar(
          title: AppStrings.facebookLoginDone,
          isError: false,
        );
      } else {
        WidgetHelper.customSnackBar(
          title: AppStrings.facebookLoginFails,
          isError: true,
        );
      }
    } catch (e) {
      WidgetHelper.customSnackBar(title: e.toString(), isError: true);
    }
  }

  /// Logout
  static Future<void> logout() async {
    try {
      await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      WidgetHelper.customSnackBar(title: e.toString(), isError: true);
    }
  }
}
