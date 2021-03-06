// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCAkRs5dLvGzLCR56D2VaRwhKWHWolOeWI',
    appId: '1:405079895193:web:94d326b0d21250ca155c08',
    messagingSenderId: '405079895193',
    projectId: 'drussell22-trivia-app',
    authDomain: 'drussell22-trivia-app.firebaseapp.com',
    storageBucket: 'drussell22-trivia-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcEARmJYJYkezjKHm7UukzT-x2gqRcoXM',
    appId: '1:405079895193:android:ac2630347658ae74155c08',
    messagingSenderId: '405079895193',
    projectId: 'drussell22-trivia-app',
    storageBucket: 'drussell22-trivia-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4QDB_dJs_TkCE0FEPpg_KX9W4eO-RfeM',
    appId: '1:405079895193:ios:b54ab454aba5beb4155c08',
    messagingSenderId: '405079895193',
    projectId: 'drussell22-trivia-app',
    storageBucket: 'drussell22-trivia-app.appspot.com',
    iosClientId: '405079895193-9dpimhp09enfngl24i0phkb193qpf04v.apps.googleusercontent.com',
    iosBundleId: 'edu.uco.drussell22.triviaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD4QDB_dJs_TkCE0FEPpg_KX9W4eO-RfeM',
    appId: '1:405079895193:ios:b54ab454aba5beb4155c08',
    messagingSenderId: '405079895193',
    projectId: 'drussell22-trivia-app',
    storageBucket: 'drussell22-trivia-app.appspot.com',
    iosClientId: '405079895193-9dpimhp09enfngl24i0phkb193qpf04v.apps.googleusercontent.com',
    iosBundleId: 'edu.uco.drussell22.triviaApp',
  );
}
