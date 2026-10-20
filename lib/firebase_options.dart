// File generated template for FirebaseOptions.
// Replace the placeholder values below with your actual Firebase project configuration,
// or run `flutterfire configure` to auto-generate this file.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAp5BUqpbStVveuD4YbeYAicrY83ZdHFPc',
    appId: '1:1046840131322:web:88ab074555b7a109fc9343',
    messagingSenderId: '1046840131322',
    projectId: 'mad-activity5-auth',
    authDomain: 'mad-activity5-auth.firebaseapp.com',
    storageBucket: 'mad-activity5-auth.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCVab0O6oDehkTKOvxUkMWTUzGR5Xq3mwQ',
    appId: '1:1046840131322:android:6d918f20a43ab714fc9343',
    messagingSenderId: '1046840131322',
    projectId: 'mad-activity5-auth',
    storageBucket: 'mad-activity5-auth.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVab0O6oDehkTKOvxUkMWTUzGR5Xq3mwQ',
    appId: '1:1046840131322:android:6d918f20a43ab714fc9343',
    messagingSenderId: '1046840131322',
    projectId: 'mad-activity5-auth',
    storageBucket: 'mad-activity5-auth.firebasestorage.app',
    iosBundleId: 'com.example.studentAuthSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCVab0O6oDehkTKOvxUkMWTUzGR5Xq3mwQ',
    appId: '1:1046840131322:android:6d918f20a43ab714fc9343',
    messagingSenderId: '1046840131322',
    projectId: 'mad-activity5-auth',
    storageBucket: 'mad-activity5-auth.firebasestorage.app',
    iosBundleId: 'com.example.studentAuthSystem',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAp5BUqpbStVveuD4YbeYAicrY83ZdHFPc',
    appId: '1:1046840131322:web:88ab074555b7a109fc9343',
    messagingSenderId: '1046840131322',
    projectId: 'mad-activity5-auth',
    authDomain: 'mad-activity5-auth.firebaseapp.com',
    storageBucket: 'mad-activity5-auth.firebasestorage.app',
  );
}
