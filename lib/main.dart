import 'package:chatflutter/chatScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatflutter/shared/Constants.dart';
import 'login.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   var email = pref.getString("email");

//   runApp(MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: email == null ? LoginPage() : ChatScreen()));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.getString("email");

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: email == null ? LoginPage() : ChatScreen()));
}
