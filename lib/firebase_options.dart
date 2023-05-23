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
    apiKey: 'AIzaSyA4e-QRyx7AAqXaD86vmKp3xpBJH6OfNKg',
    appId: '1:509102065983:web:73b79a9326b4df2ab36b8a',
    messagingSenderId: '509102065983',
    projectId: 'whatsapp-clone-173cc',
    authDomain: 'whatsapp-clone-173cc.firebaseapp.com',
    storageBucket: 'whatsapp-clone-173cc.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCA0EOLe2o5t-hMA6-EKQEZN9c5ejBH7to',
    appId: '1:509102065983:android:a6d725cfdbb6bb5db36b8a',
    messagingSenderId: '509102065983',
    projectId: 'whatsapp-clone-173cc',
    storageBucket: 'whatsapp-clone-173cc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAquJiRLf4mul5V-46qbZIzp2jjtGszfgg',
    appId: '1:509102065983:ios:bd53b0242d2d9bb7b36b8a',
    messagingSenderId: '509102065983',
    projectId: 'whatsapp-clone-173cc',
    storageBucket: 'whatsapp-clone-173cc.appspot.com',
    iosClientId: '509102065983-s3jjotjfl20tg7rt58pu1clqp909l3lt.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAquJiRLf4mul5V-46qbZIzp2jjtGszfgg',
    appId: '1:509102065983:ios:bd53b0242d2d9bb7b36b8a',
    messagingSenderId: '509102065983',
    projectId: 'whatsapp-clone-173cc',
    storageBucket: 'whatsapp-clone-173cc.appspot.com',
    iosClientId: '509102065983-s3jjotjfl20tg7rt58pu1clqp909l3lt.apps.googleusercontent.com',
    iosBundleId: 'com.example.whatsappClone',
  );
}
