import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "", _password = "", type = "login";
  User? user;
  bool _success = false;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  type == "login" ? 'Login' : "Register",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            TextFormField(
              onSaved: (value) {
                _email = value!;
              },
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              onSaved: (value) {
                _password = value!;
              },
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (type == "login") {
                        _login();
                      } else if (type == "register") {
                        _register();
                      }
                    }
                  },
                  child: Text(type == "login" ? 'Login' : "Register")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    if (type == "login")
                      setState(() {
                        type = "register";
                      });
                    else
                      setState(() {
                        type = "login";
                      });
                  },
                  child: Text(type == "login" ? 'Create an Account' : "Login")),
            )
          ],
        ),
      ),
    )));
  }

  Future<void> _login() async {
    try {
      final User? user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      ))
              .user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user!.email} signed in'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Email & Password'),
        ),
      );
    }
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
