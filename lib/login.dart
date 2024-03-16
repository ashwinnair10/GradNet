// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors, avoid_print

import 'package:alumniyearbook/forgot.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './dashboard.dart';
import './signup.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to Dashboard on successful login
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      }
    } catch (e) {
      // Handle errors here
      print("Error signing in: $e");
      // You can show error messages to the user if needed
    }
  }

  void _navigateToSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
              ),
              Image.network('https://i.ibb.co/ZBrnGH8/ic-launcher.png',
                  height: 220),
              SizedBox(
                height: 10,
              ),
              // Email TextField
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
              SizedBox(
                height: 20,
              ),
              // Password TextField
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: 'Password',
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(150, 20, 150, 20),
                  backgroundColor: Color.fromARGB(255, 1, 62, 133),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                onPressed: _signInWithEmailAndPassword,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Text(
                    'Login',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPage(),
                    ),
                  ),
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 1, 62, 133),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New User?'),
                  TextButton(
                    onPressed: _navigateToSignUpPage,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
