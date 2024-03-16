// ignore_for_file: prefer_const_constructors
import './login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Oswald'),
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;

      default:
        return FirebaseOptions(
          apiKey: 'AIzaSyCzcvsllfFnIphI6uE2AHMiEDEPgyA-KsE',
          appId: '1:507075046969:android:4535142b7b6c5df40867e8',
          messagingSenderId: '507075046969',
          projectId: 'alumniyearbook-1276f',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzcvsllfFnIphI6uE2AHMiEDEPgyA-KsE',
    appId: '1:507075046969:android:4535142b7b6c5df40867e8',
    messagingSenderId: '507075046969',
    projectId: 'alumniyearbook-1276f',
    databaseURL:
        'https://alumniyearbook-1276f-default-rtdb.asia-southeast1.firebasedatabase.app/',
    storageBucket: 'gs://alumniyearbook-1276f.appspot.com',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
