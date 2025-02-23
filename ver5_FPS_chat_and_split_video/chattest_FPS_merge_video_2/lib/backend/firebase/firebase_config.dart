import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCn8mwJRGM0CyCdgzyLmcV5coepywCDduQ",
            authDomain: "chattest-48067.firebaseapp.com",
            projectId: "chattest-48067",
            storageBucket: "chattest-48067.firebasestorage.app",
            messagingSenderId: "631744777818",
            appId: "1:631744777818:web:c47b13deadfd6a0a845263",
            measurementId: "G-N51Z7ZEB45"));
  } else {
    await Firebase.initializeApp();
  }
}
