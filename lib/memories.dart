// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_final_fields, avoid_print, avoid_unnecessary_containers

import 'package:alumniyearbook/alumniprofile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Memories extends StatefulWidget {
  Memories({Key? key}) : super(key: key);

  @override
  State<Memories> createState() => _MemoriesState();
}

class _MemoriesState extends State<Memories> {
  TextEditingController _contentController = TextEditingController();

  Future<void> _uploadMemory() async {
    try {
      String content = _contentController.text.trim();
      String? userId = FirebaseAuth.instance.currentUser?.email;
      if (userId != null) {
        // Add a new document to the 'memories' subcollection
        await FirebaseFirestore.instance
            .collection('USERS')
            .doc(userId)
            .collection('memories')
            .add({
          'content': content,
          'timestamp': FieldValue.serverTimestamp(),
          'url': '',
        });
      }
      _contentController.clear();
    } catch (e) {
      print("Error uploading memory: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memories'),
        backgroundColor: Color.fromARGB(255, 1, 62, 133),
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('USERS').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Iterate through all users' documents
                return ListView(
                  children: snapshot.data!.docs.map((userDoc) {
                    return StreamBuilder<QuerySnapshot>(
                      stream:
                          userDoc.reference.collection('memories').snapshots(),
                      builder: (context, memoriesSnapshot) {
                        if (memoriesSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(); // Placeholder while loading memories
                        }
                        if (memoriesSnapshot.hasError) {
                          return Text('Error: ${memoriesSnapshot.error}');
                        }

                        // Iterate through memories of this user
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: memoriesSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final memory =
                                    memoriesSnapshot.data!.docs[index];
                                return Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 243, 243, 243),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ListTile(
                                        subtitle: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                memory['content'],
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              if (memory['url'] != '')
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    memory['url'],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        title: TextButton(
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.all(0),
                                              alignment: Alignment.centerLeft),
                                          child: Text(
                                            '${userDoc['name']}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 1, 62, 133),
                                            ),
                                          ),
                                          onPressed: () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePage(
                                                  userDoc['name'] ?? '',
                                                  userDoc['roll_no'],
                                                  userDoc['graduation_year'],
                                                  userDoc['email'],
                                                  userDoc['url'],
                                                  userDoc['place'],
                                                  userDoc['industry'],
                                                  userDoc['phone_number'],
                                                ),
                                              ),
                                            ),
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                hintText: 'Enter your memories...',
                labelText: 'Enter your memories...',
              ),
            ),
          ),
          TextButton(
            onPressed: _uploadMemory,
            child: Text(
              'Post Memory',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 62, 133),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
