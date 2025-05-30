import 'dart:developer';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacebookFirebaseLogin {
  static Future<UserCredential?> loginWithFacebook() async {
    try {
      // Trigger Facebook login
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // Create a Firebase credential
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);

        // Sign in to Firebase
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        log("✅ Facebook login successful. User: ${userCredential.user?.displayName}");
        return userCredential;
      } else {
        log("❌ Facebook login failed: ${result.status}");
        return null;
      }
    } catch (e, s) {
      log("🔥 Error during Facebook login with Firebase", error: e, stackTrace: s);
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
      log("✅ Logged out from Facebook and Firebase");
    } catch (e) {
      log("❌ Error during logout: $e");
    }
  }
}
