import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_django_demo/details.dart';
import 'package:firebase_django_demo/home.dart';
import 'package:firebase_django_demo/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          if (snapshot.data == null)
            return LoginPage();
          else {
            User user = snapshot.data as User;
            if (user.displayName == "" || user.displayName == null)
              return DetailsPage();
            else
              return HomePage();
          }
        },
      ),
    );
  }
}
