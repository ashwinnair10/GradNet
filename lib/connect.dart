// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:alumniyearbook/alumniprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Connect extends StatefulWidget {
  Connect({Key? key}) : super(key: key);

  @override
  State<Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  late CollectionReference<Map<String, dynamic>> usersCollection;

  @override
  void initState() {
    super.initState();
    usersCollection = FirebaseFirestore.instance.collection('USERS');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect'),
        backgroundColor: Color.fromARGB(255, 1, 62, 133),
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: usersCollection
            .doc(FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!.data();
          final List<dynamic>? friendEmails = userData!['friends'];

          return ListView(
            children: [
              _buildSectionHeader('My Friends'),
              _buildFriendsList(friendEmails),
              SizedBox(height: 20),
              _buildSectionHeader('Other Users'),
              _buildOtherUsersList(friendEmails,
                  FirebaseAuth.instance.currentUser!.email as String),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 1, 62, 133),
        ),
      ),
    );
  }

  Widget _buildFriendsList(List<dynamic>? friendEmails) {
    if (friendEmails == null || friendEmails.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('You have not added friends yet.'),
      );
    }
    return Column(
      children: friendEmails.map((email) {
        return FutureBuilder<DocumentSnapshot>(
          future: usersCollection.doc(email).get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> friendSnapshot) {
            if (friendSnapshot.connectionState == ConnectionState.done) {
              if (friendSnapshot.hasError) {
                return Text("Failed to load friend's data");
              }
              if (friendSnapshot.hasData && friendSnapshot.data!.exists) {
                final friendData =
                    friendSnapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 221, 221, 221),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                friendData['name'] ?? '',
                                friendData['roll_no'],
                                friendData['graduation_year'],
                                friendData['email'],
                                friendData['url'],
                                friendData['place'],
                                friendData['industry'],
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            friendData['url'],
                          ),
                        ),
                        title: Text(friendData['name']),
                        subtitle: Text(
                            'Batch of ${friendData['graduation_year'] ?? ''}'),
                        trailing: IconButton(
                          icon: Icon(Icons.person_remove),
                          onPressed: () {
                            _removeFriend(email);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                );
              }
              return Text("Friend's data does not exist");
            }
            return SizedBox();
          },
        );
      }).toList(),
    );
  }

  Widget _buildOtherUsersList(
      List<dynamic>? friendEmails, String currentUserEmail) {
    return StreamBuilder<QuerySnapshot>(
      stream: usersCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        }

        final otherUsers = snapshot.data!.docs
            .where((user) =>
                user.id != currentUserEmail && !friendEmails!.contains(user.id))
            .toList();

        if (otherUsers.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('No other users found.'),
          );
        }

        return Column(
          children: otherUsers.map((user) {
            final userData = user.data() as Map<String, dynamic>;
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 221, 221, 221),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            userData['name'] ?? '',
                            userData['roll_no'],
                            userData['graduation_year'],
                            userData['email'],
                            userData['url'],
                            userData['place'],
                            userData['industry'],
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        userData['url'],
                      ),
                    ),
                    title: Text(userData['name']),
                    subtitle:
                        Text('Batch of ${userData['graduation_year'] ?? ''}'),
                    trailing: IconButton(
                      icon: Icon(Icons.person_add),
                      onPressed: () {
                        _addFriend(user.id);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  void _addFriend(String friendId) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      usersCollection.doc(currentUser.email).update({
        'friends': FieldValue.arrayUnion([friendId])
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Friend added successfully!'),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add friend: $error'),
          ),
        );
      });
    }
  }

  void _removeFriend(String friendId) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      usersCollection.doc(currentUser.email).update({
        'friends': FieldValue.arrayRemove([friendId])
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Friend removed successfully!'),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove friend: $error'),
          ),
        );
      });
    }
  }
}
