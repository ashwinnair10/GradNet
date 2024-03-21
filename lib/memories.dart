// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_final_fields, prefer_const_constructors_in_immutables, avoid_print

import 'dart:io';

import 'package:alumniyearbook/alumniprofile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Memories extends StatefulWidget {
  Memories({Key? key}) : super(key: key);

  @override
  State<Memories> createState() => _MemoriesState();
}

class _MemoriesState extends State<Memories> {
  TextEditingController _contentController = TextEditingController();
  File? _image;

  Future<void> _uploadMemory() async {
    try {
      String content = _contentController.text.trim();
      String? userId = FirebaseAuth.instance.currentUser?.email;
      if (userId != null) {
        String url = '';
        if (_image != null) {
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('memories')
              .child(DateTime.now().millisecondsSinceEpoch.toString());
          await ref.putFile(_image!);
          url = await ref.getDownloadURL();
        }
        if (_contentController.text != '') {
          await FirebaseFirestore.instance
              .collection('USERS')
              .doc(userId)
              .collection('memories')
              .add({
            'content': content,
            'timestamp': FieldValue.serverTimestamp(),
            'url': url,
          });
        }
      }
      _contentController.clear();
      setState(() {
        _image = null;
      });
    } catch (e) {
      print("Error uploading memory: $e");
    }
  }

  Future<void> _getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
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
                                              SizedBox(height: 5),
                                              if (memory['url'] != null &&
                                                  memory['url'] != '')
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    memory['url'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        title: TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(0),
                                            alignment: Alignment.centerLeft,
                                          ),
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
                suffixIcon: IconButton(
                  onPressed: _getImage,
                  icon: Icon(Icons.attach_file),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: _uploadMemory,
                child: Text(
                  'Post Memory',
                  style: TextStyle(
                    color: Color.fromARGB(255, 1, 62, 133),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
