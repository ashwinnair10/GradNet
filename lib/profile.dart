// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:alumniyearbook/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './edit_profile.dart';
import './connect.dart'; // Import the Connect screen where the list of friends is displayed

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _name = "";
  late String _email = "";
  late String _rollNo = "";
  late String _graduationYear = "";
  late String _url = "";
  late String _phoneNumber = "";
  late String loc = "";
  late String ind = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final User? user = _auth.currentUser;
      final DocumentSnapshot userSnapshot =
          await _firestore.collection('USERS').doc(user?.email).get();

      setState(() {
        _name = userSnapshot.get('name');
        _email = user!.email!;
        _rollNo = userSnapshot.get('roll_no');
        _graduationYear = userSnapshot.get('graduation_year');
        _url = userSnapshot.get('url');
        _phoneNumber = userSnapshot.get('phone_number');
        loc = userSnapshot.get('place');
        ind = userSnapshot.get('industry');
      });
    } catch (e) {
      // Handle errors here
      print("Error fetching user data: $e");
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Remove all existing routes and navigate to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false, // Prevents going back to the previous route
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile'),
        elevation: 0,
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 1, 62, 133),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Connect()),
              );
            },
            icon: Icon(
              Icons.people,
              color: Color.fromARGB(255, 1, 62, 133),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Navigate to edit profile page
              final Map<String, dynamic>? newProfileData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    name: _name,
                    email: _email,
                    rollNo: _rollNo,
                    graduationYear: _graduationYear,
                    phone: _phoneNumber,
                    loc: loc,
                    ind: ind,
                  ),
                ),
              );

              // If new profile data is not null, update Firestore document
              if (newProfileData != null) {
                try {
                  await _firestore
                      .collection('USERS')
                      .doc(_email)
                      .update(newProfileData);
                  _fetchUserData(); // Update displayed data
                } catch (e) {
                  print("Error updating profile data: $e");
                }
              }
            },
            child: Text(
              'Edit Profile',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 62, 133),
              ),
            ),
          ),
          IconButton(
            onPressed: _logout,
            icon: Icon(
              Icons.logout,
              color: Color.fromARGB(255, 1, 62, 133),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 1, 62, 133),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _email,
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(255, 209, 209, 209),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_url),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _phoneNumber,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 1, 62, 133),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Roll Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _rollNo,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 1, 62, 133),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Graduation Year',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _graduationYear,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 1, 62, 133),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    loc,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 1, 62, 133),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Industry',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ind,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 1, 62, 133),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
