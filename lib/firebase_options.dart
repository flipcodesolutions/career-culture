// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCIC-NLu-i_11x3z11pdI0oKN2lTXKEcUk',
    appId: '1:454305239270:web:53c9d524b189791c086b27',
    messagingSenderId: '454305239270',
    projectId: 'career-culture-99939',
    authDomain: 'career-culture-99939.firebaseapp.com',
    storageBucket: 'career-culture-99939.firebasestorage.app',
    measurementId: 'G-JW63HBBHJ4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIXo1lubPMS5ba2Lp9_k_MwMU9Qw5QfrA',
    appId: '1:454305239270:android:09f8077a8c4f2794086b27',
    messagingSenderId: '454305239270',
    projectId: 'career-culture-99939',
    storageBucket: 'career-culture-99939.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBYy8vpjVdlLOverKjHlJCbbUd-ffg05t4',
    appId: '1:454305239270:ios:1640fda4fd537979086b27',
    messagingSenderId: '454305239270',
    projectId: 'career-culture-99939',
    storageBucket: 'career-culture-99939.firebasestorage.app',
    iosBundleId: 'com.flipcode.mindfulyouth.mindfulYouth',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBYy8vpjVdlLOverKjHlJCbbUd-ffg05t4',
    appId: '1:454305239270:ios:1640fda4fd537979086b27',
    messagingSenderId: '454305239270',
    projectId: 'career-culture-99939',
    storageBucket: 'career-culture-99939.firebasestorage.app',
    iosBundleId: 'com.flipcode.mindfulyouth.mindfulYouth',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCIC-NLu-i_11x3z11pdI0oKN2lTXKEcUk',
    appId: '1:454305239270:web:2d650a8963806733086b27',
    messagingSenderId: '454305239270',
    projectId: 'career-culture-99939',
    authDomain: 'career-culture-99939.firebaseapp.com',
    storageBucket: 'career-culture-99939.firebasestorage.app',
    measurementId: 'G-C8RY1M5PKF',
  );
}
