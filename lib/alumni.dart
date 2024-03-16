// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'alumniprofile.dart'; // Assuming you have defined ProfilePage in alumniprofile.dart

class Alumni extends StatefulWidget {
  Alumni({Key? key}) : super(key: key);

  @override
  State<Alumni> createState() => _AlumniState();
}

class _AlumniState extends State<Alumni> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumni'),
        backgroundColor: Color.fromARGB(255, 0, 62, 121),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) {
                setState(() {}); // Trigger rebuild when search term changes
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
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
                final QuerySnapshot usersSnapshot = snapshot.data!;
                final List<DocumentSnapshot> users = usersSnapshot.docs;

                List<DocumentSnapshot> filteredUsers = users.where((user) {
                  Map<String, dynamic> userData =
                      user.data() as Map<String, dynamic>;

                  // Search logic
                  String searchTerm = _searchController.text.toLowerCase();
                  String name = userData['name']?.toLowerCase() ?? '';
                  String rollNo = userData['roll_no']?.toLowerCase() ?? '';
                  String graduationYear =
                      userData['graduation_year']?.toLowerCase() ?? '';
                  String location = userData['place']?.toLowerCase() ?? '';
                  String industry = userData['industry']?.toLowerCase() ?? '';

                  // Check if any of the fields contain the search term
                  return name.contains(searchTerm) ||
                      rollNo.contains(searchTerm) ||
                      graduationYear.contains(searchTerm) ||
                      location.contains(searchTerm) ||
                      industry.contains(searchTerm);
                }).toList();

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final userData =
                        filteredUsers[index].data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 233, 233, 233),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                userData['url'],
                              ),
                            ),
                            title: Text(userData['name'] ?? ''),
                            subtitle: Text(
                                'Batch of ${userData['graduation_year'] ?? ''}'),
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
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
