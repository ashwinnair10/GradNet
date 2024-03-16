// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './dashboard.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _graduationYearController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController loc = TextEditingController();

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        // Store user details in Firestore collection 'USERS'
        await _firestore
            .collection('USERS')
            .doc(userCredential.user?.email)
            .set({
          'name': _nameController.text,
          'email': _emailController.text,
          'roll_no': _rollNoController.text,
          'graduation_year': _graduationYearController.text,
          'phone_number': _phoneNumberController.text,
          'place': loc.text, // Store phone number
          'url':
              'https://t3.ftcdn.net/jpg/01/65/63/94/360_F_165639425_kRh61s497pV7IOPAjwjme1btB8ICkV0L.jpg'
        });

        // Navigate to Dashboard on successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      }
    } catch (e) {
      // Handle errors here
      print("Error signing up: $e");
      // You can show error messages to the user if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 1, 62, 133),
          ),
        ),
        title: Text(
          'Sign Up',
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
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                hintText: 'Name',
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 15),
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
            SizedBox(height: 15),
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
            SizedBox(height: 15),
            TextField(
              controller: _rollNoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                hintText: 'Roll Number',
                labelText: 'Roll Number',
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _graduationYearController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                hintText: 'Graduation Year',
                labelText: 'Graduation Year',
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                hintText: 'Phone Number', // Add hint for phone number
                labelText: 'Phone Number', // Add label for phone number
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: loc,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                hintText: 'Location', // Add hint for phone number
                labelText: 'Location', // Add label for phone number
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(150, 20, 150, 20),
                backgroundColor: Color.fromARGB(255, 1, 62, 133),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              onPressed: _signUpWithEmailAndPassword,
              child: Text(
                'Sign Up',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
