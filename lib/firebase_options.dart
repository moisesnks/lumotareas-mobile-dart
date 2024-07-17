/// @nodoc
library;
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB1r5fBqZA8AMwtyiYXAQYGuhMGgvSJ-jw',
    appId: '1:293636913953:web:1599084564bd85efea9c60',
    messagingSenderId: '293636913953',
    projectId: 'lumotareas-858a3',
    authDomain: 'lumotareas-858a3.firebaseapp.com',
    storageBucket: 'lumotareas-858a3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyu--_FOP_ncDoTN0SgXc9yAQWkEtO7Zg',
    appId: '1:293636913953:android:666905316a498dbfea9c60',
    messagingSenderId: '293636913953',
    projectId: 'lumotareas-858a3',
    storageBucket: 'lumotareas-858a3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHNkYzH06mZnGxqU5mx_U4HaQ0P0rE3iI',
    appId: '1:293636913953:ios:7ed12667fb3b548dea9c60',
    messagingSenderId: '293636913953',
    projectId: 'lumotareas-858a3',
    storageBucket: 'lumotareas-858a3.appspot.com',
    androidClientId:
        '293636913953-gg8ptti6ibo76ojjv5t88ljmtkt1ef17.apps.googleusercontent.com',
    iosClientId:
        '293636913953-arqtaib911fbk0p2mbl5buqvc78g2s2r.apps.googleusercontent.com',
    iosBundleId: 'com.lumonidy.lumotareas',
  );
}
