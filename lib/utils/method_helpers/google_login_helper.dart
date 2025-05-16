import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider/login_provider.dart';
import '../widget_helper/widget_helper.dart';

class GoogleLoginHelper {
  static Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      // Optional: Force account selection each time
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      /// if no account selected
      if (googleUser == null) {
        if (context.mounted) {
          WidgetHelper.customSnackBar(
            // context: context,
            title: "Google Sign-In Failed",
            isError: true,
          );
        }
        return;
      }
      LoginProvider loginProvider = context.read<LoginProvider>();
      // UserProvider profileProvider = context.read<UserProvider>();

      ///
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      if (googleAuth == null) {
        WidgetHelper.customSnackBar(
          // context: context,
          title: "Google Authentication failed",
          isError: true,
        );
        return;
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      User? user = userCredential.user;

      if (user == null) {
        WidgetHelper.customSnackBar(
          // context: context,
          title: "Firebase Authentication failed",
          isError: true,
        );
        return;
      }

      // WidgetHelper.customSnackBar(
      //   context: context,
      //   title: "Signed in as ${user.email}",
      // );

      // if (context.mounted) {
      //   Navigator.of(context).push(
      //     PageRouteBuilder(
      //       transitionDuration: Duration(milliseconds: 300),
      //       pageBuilder:
      //           (context, animation, secondaryAnimation) =>
      //               MainScreen(setIndex: 0),
      //     ),
      //   );
      // }
      if (!context.mounted) return;
      await loginProvider.checkEmailExit(
        context: context,
        email: user.email ?? "",
      );
      // if (emailExists) {
      //   if (context.mounted) {
      //     redirectToMainScreen(context);
      //   }
      // } else {
      //   bool profileCreated = await profileProvider.createProfile(
      //     context: context,
      //     email: user.email ?? "",
      //     name: user.displayName ?? "",
      //   );
      //   if (profileCreated) {
      //     if (context.mounted) {
      //       redirectToMainScreen(context);
      //     }
      //   } else {
      //     if (context.mounted) {
      //       abortSignInAndRedirectToLoginPage(context);
      //     }
      //   }
      // }
    } catch (e) {
      WidgetHelper.customSnackBar(
        // context: context,
        title: "Error: ${e.toString()}",
        isError: true,
      );
    }
  }

  // static void abortSignInAndRedirectToLoginPage(BuildContext context) {
  //   signOut();
  //   Navigator.of(context).pop();
  //   WidgetHelper.customSnackBar(
  //     context: context,
  //     title: AppStrings.signInFailed,
  //     isError: true,
  //   );
  // }

  // static void redirectToMainScreen(BuildContext context) {
  //   Navigator.of(context).pushAndRemoveUntil(
  //     MaterialPageRoute(builder: (context) => MainScreen()),
  //     (route) => false,
  //   );
  //   WidgetHelper.customSnackBar(context: context, title: AppStrings.welcome);
  // }

  /// Sign out user
  // static Future<void> signOut() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     await GoogleSignIn().signOut();
  //   } catch (e) {
  //     Environment.debugMode
  //         ? debugPrint("Sign-out error: ${e.toString()}")
  //         : null;
  //   }
  // }
}
