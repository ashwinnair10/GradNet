// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String alumniName, rollno, year, email, url, loc, ind, phone;

  ProfilePage(
    this.alumniName,
    this.rollno,
    this.year,
    this.email,
    this.url,
    this.loc,
    this.ind,
    this.phone,
  );

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool isFriend = false;
  late String? currentUserEmail = "";

  @override
  void initState() {
    super.initState();
    getCurrentUserEmail();
    checkFriendStatus();
  }

  Future<void> getCurrentUserEmail() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserEmail = currentUser.email;
    }
  }

  Future<void> checkFriendStatus() async {
    if (currentUserEmail == widget.email) {
      // If viewing own profile, hide the button
      setState(() {
        isFriend = false;
      });
    } else {
      final userDoc = await FirebaseFirestore.instance
          .collection('USERS')
          .doc(currentUserEmail)
          .get();
      final List<dynamic>? currentUserFriends = userDoc['friends'];

      setState(() {
        isFriend = currentUserFriends != null &&
            currentUserFriends.contains(widget.email);
      });
    }
  }

  Future<void> addFriend() async {
    final currentUserDoc =
        FirebaseFirestore.instance.collection('USERS').doc(currentUserEmail);

    final currentUserFriends = await currentUserDoc
        .get()
        .then((doc) => doc.get('friends') as List<dynamic>?);

    if (currentUserFriends != null &&
        !currentUserFriends.contains(widget.email)) {
      // If the friend is not already in the current user's friends list
      currentUserFriends.add(widget.email);
      await currentUserDoc.update({'friends': currentUserFriends});
      setState(() {
        isFriend = true;
      });
    }
  }

  Future<void> removeFriend() async {
    final currentUserDoc =
        FirebaseFirestore.instance.collection('USERS').doc(currentUserEmail);

    final currentUserFriends = await currentUserDoc
        .get()
        .then((doc) => doc.get('friends') as List<dynamic>?);

    if (currentUserFriends != null &&
        currentUserFriends.contains(widget.email)) {
      // If the friend is in the current user's friends list
      currentUserFriends.remove(widget.email);
      await currentUserDoc.update({'friends': currentUserFriends});
      setState(() {
        isFriend = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 1, 62, 133),
          ),
        ),
        actions: currentUserEmail == widget.email
            ? []
            : [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (isFriend) {
                      removeFriend();
                    } else {
                      addFriend();
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        isFriend ? Icons.remove : Icons.add,
                        color: Color.fromARGB(255, 1, 62, 133),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        isFriend ? 'Remove Friend' : 'Add Friend',
                        style: TextStyle(
                          color: Color.fromARGB(255, 1, 62, 133),
                        ),
                      ),
                    ],
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
                            widget.alumniName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.email,
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color.fromARGB(255, 209, 209, 209),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(widget.url),
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
                    widget.phone,
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
                    widget.rollno,
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
                    widget.year,
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
                    widget.loc,
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
                    widget.ind,
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
