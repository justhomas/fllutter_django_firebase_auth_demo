import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_django_demo/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class DetailsPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  DetailsPage({Key? key}) : super(key: key);
  String _date = "", _first_name = "", _last_name = "", _about = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Please fill in profile details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Text('Please Provide Below Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      )),
                )),
                TextFormField(
                  decoration: InputDecoration(labelText: "First Name"),
                  onSaved: (value) {
                    _first_name = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Last Name"),
                  onSaved: (value) {
                    _last_name = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "About You"),
                  minLines: 3,
                  maxLines: 5,
                  onSaved: (value) {
                    _about = value!;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(labelText: "Date of Birth"),
                  onSaved: (value) {
                    _date = value!;
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.save();
                      _updateProfile().then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("User updated")));
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //builder: (context) => HomePage()));
                      });
                    },
                    child: Text('Save Details'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    //can be stored locally and then network call if not available retry later
    List l = await Future.wait([
      http.put(
          Uri.parse("http://10.0.2.2:8000/api/users/" +
              FirebaseAuth.instance.currentUser!.uid +
              "/"),
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Token " + await FirebaseAuth.instance.currentUser!.getIdToken()
          },
          body: jsonEncode({
            "first_name": _first_name,
            "last_name": _last_name,
            "userprofile": {"bio": _about, "dob": _date}
          })),
      FirebaseAuth.instance.currentUser!
          .updateDisplayName(_first_name + " " + _last_name)
    ]);
  }
}
