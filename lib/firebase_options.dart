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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOrU3ACNfyvml88AHL8OyH6mGuGmrc09k',
    appId: '1:528907825677:android:e7456c3b586bc0c0035b44',
    messagingSenderId: '528907825677',
    projectId: 'findher-595dd',
    databaseURL: 'https://findher-595dd-default-rtdb.firebaseio.com',
    storageBucket: 'findher-595dd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsm738SoLcTKzx8VuJF39P-dHDppVJH7Y',
    appId: '1:528907825677:ios:844e1eb7fa5aa7e7035b44',
    messagingSenderId: '528907825677',
    projectId: 'findher-595dd',
    databaseURL: 'https://findher-595dd-default-rtdb.firebaseio.com',
    storageBucket: 'findher-595dd.appspot.com',
    iosClientId: '528907825677-bkmps5jkblpo5omkuafa6k23ekkn6kum.apps.googleusercontent.com',
    iosBundleId: 'com.example.helloWorld',
  );
}
