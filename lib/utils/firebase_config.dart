import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

const firebaseOptions = kIsWeb
    ? FirebaseOptions(
        apiKey: "AIzaSyCZmFcmHAlS8RnKL9mmIxU6z2P7Z9ZcANk",
        authDomain: "agora-demo-cff2a.firebaseapp.com",
        projectId: "agora-demo-cff2a",
        storageBucket: "agora-demo-cff2a.appspot.com",
        messagingSenderId: "134487991354",
        appId: "1:134487991354:web:ae2f37ab078617944e4103",
      )
    : null;
