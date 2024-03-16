// ignore_for_file: unused_import, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './dashboard.dart'; // Import the Dashboard page for navigation after password reset

class ForgotPage extends StatefulWidget {
  ForgotPage({Key? key}) : super(key: key);

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);

      // Show a confirmation dialog to inform the user that an email has been sent
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset'),
            content: Text(
                'An email has been sent to ${_emailController.text} with instructions to reset your password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors here
      print("Error resetting password: $e");
      // You can show error messages to the user if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 1, 62, 133),
          ),
        ),
        title: Text(
          'Forgot Password',
          style: TextStyle(
            color: Color.fromARGB(255, 1, 62, 133),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                hintText: 'Email',
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                backgroundColor: Color.fromARGB(255, 1, 62, 133),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              onPressed: _resetPassword,
              child: Text(
                'Reset Password',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
