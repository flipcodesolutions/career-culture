import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import '../../app_const/app_strings.dart';
import '../../provider/user_provider/login_provider.dart';
import '../widget_helper/widget_helper.dart';

class FacebookFirebaseLogin {
  static Future<void> loginWithFacebook(BuildContext context) async {
    try {
      // Ensure previous Facebook session is logged out
      await FacebookAuth.instance.logOut();

      final LoginResult result = await FacebookAuth.instance.login();
      // Call the same logic as Google to validate user from backend
      final loginProvider = context.read<LoginProvider>();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        try {
          // Attempt to sign in with Facebook credential
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

          await loginProvider.checkEmailExit(
            context: context,
            email: user.email ?? "",
          );

          WidgetHelper.customSnackBar(
            title: AppStrings.facebookLoginDone,
            isError: false,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // User exists with a different sign-in method
            // Fetch the email from the Facebook credential
            final email =
                e.email; // The email associated with the Facebook account
            if (email == null) {
              WidgetHelper.customSnackBar(
                title: "Error: Email not found for Facebook account.",
                isError: true,
              );
              return;
            }
            await loginProvider.checkEmailExit(context: context, email: email);
          } else {
            // Other FirebaseAuthException errors
            WidgetHelper.customSnackBar(
              title: e.message ?? "An unknown Firebase error occurred",
              isError: true,
            );
          }
        }
      } else {
        // Facebook login failed (e.g., user cancelled)
        WidgetHelper.customSnackBar(
          title: AppStrings.facebookLoginFails,
          isError: true,
        );
      }
    } catch (e) {
      // General errors (network issues, etc.)
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
