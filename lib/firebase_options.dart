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
    apiKey: 'AIzaSyAMLw3J9--TNFPWqK2yCh_hTJEHrev-__s',
    appId: '1:844935327393:web:cdf8378f8cb4fa580e8ae0',
    messagingSenderId: '844935327393',
    projectId: 'find-her-65a18',
    authDomain: 'find-her-65a18.firebaseapp.com',
    databaseURL: 'https://find-her-65a18-default-rtdb.firebaseio.com',
    storageBucket: 'find-her-65a18.appspot.com',
    measurementId: 'G-8YF2FW9D5W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAX9qi6bZp1Z5S-_aDBkNKbWUfzmdXNJ9Y',
    appId: '1:844935327393:android:aacf2f912f7b4c4c0e8ae0',
    messagingSenderId: '844935327393',
    projectId: 'find-her-65a18',
    databaseURL: 'https://find-her-65a18-default-rtdb.firebaseio.com',
    storageBucket: 'find-her-65a18.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAsiIUQCDxVSHq35PUgtMGlFziA8UgytuM',
    appId: '1:844935327393:ios:02065214fc2bbda30e8ae0',
    messagingSenderId: '844935327393',
    projectId: 'find-her-65a18',
    databaseURL: 'https://find-her-65a18-default-rtdb.firebaseio.com',
    storageBucket: 'find-her-65a18.appspot.com',
    iosClientId: '844935327393-f4fc5enkb28i9382skbeql9drth19978.apps.googleusercontent.com',
    iosBundleId: 'com.example.helloWorld',
  );
}
