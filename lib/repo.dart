// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_final_fields, sort_child_properties_last, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repo extends StatefulWidget {
  Repo({Key? key}) : super(key: key);

  @override
  State<Repo> createState() => _RepoState();
}

class _RepoState extends State<Repo> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  late String _currentUser;
  bool _showAddRepo = false;
  List<Map<String, dynamic>> _repos = [];

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    fetchRepositories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositories'),
        backgroundColor: Color.fromARGB(255, 1, 62, 133),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context, delegate: RepoSearchDelegate(_repos));
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _repos.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> repo = _repos[index];
                  return Column(
                    children: [
                      Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width - 30,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 226, 226, 226),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            repo['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text('Uploaded by: ${repo['uploader']}'),
                          onTap: () {
                            launchUrl(Uri.parse(repo['link']));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            _showAddRepo ? buildAddRepoSection() : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showAddRepo = !_showAddRepo;
          });
        },
        child: Icon(_showAddRepo ? Icons.remove : Icons.add),
        backgroundColor: Color.fromARGB(255, 1, 62, 133),
      ),
    );
  }

  Widget buildAddRepoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            hintText: 'Title',
            labelText: 'Title',
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextField(
          controller: _linkController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            hintText: 'Link',
            labelText: 'Link',
          ),
        ),
        SizedBox(
          height: 15,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 1, 62, 133),
          ),
          onPressed: () {
            addRepo();
          },
          child: Text('Add Repository'),
        ),
      ],
    );
  }

  Future<void> fetchCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('USERS')
          .doc(user.email)
          .get();

      setState(() {
        _currentUser = snapshot.data()?['name'];
      });
    }
  }

  Future<void> fetchRepositories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> repoSnapshot =
          await FirebaseFirestore.instance.collection('REPO').get();
      _repos = repoSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching repositories: $e');
    }
  }

  Future<void> addRepo() async {
    try {
      await FirebaseFirestore.instance.collection('REPO').add({
        'title': _titleController.text,
        'link': _linkController.text,
        'uploader': _currentUser,
      });
      _titleController.clear();
      _linkController.clear();
      setState(() {
        _showAddRepo = false; // Hide "Add New Repo" section after repo is added
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Repo added successfully')));
    } catch (e) {
      print('Error adding repo: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add repo')));
    }
  }

  Future<bool> launchUrl(Uri uri) async {
    if (!['http', 'https'].contains(uri.scheme)) {
      uri = Uri.parse('https://${uri.toString()}');
    }

    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
      return true;
    } else {
      return false;
    }
  }
}

class RepoSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> repos;

  RepoSearchDelegate(this.repos);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor:
            Colors.white, // Customize the background color of the app bar
        elevation: 0, // Remove the elevation
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Customize the back button icon color
          onPressed: () {
            close(context, null);
          },
        ),
        title: TextField(
          style: TextStyle(
              color:
                  Colors.black), // Customize the text color of the search input
          cursorColor:
              Colors.black, // Customize the cursor color of the search input
          decoration: InputDecoration(
            hintText: 'Search...', // Customize the placeholder text
            hintStyle: TextStyle(
                color: Colors.grey), // Customize the placeholder text color
            border: InputBorder.none, // Remove the border
          ),
          onChanged: (value) {
            query = value;
          },
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = repos.where((repo) =>
        repo['title'].toString().toLowerCase().contains(query.toLowerCase()));
    return ListView(
      children: results
          .map((repo) => ListTile(
                title: Text(repo['title']),
                subtitle: Text('Uploaded by: ${repo['uploader']}'),
                onTap: () {
                  // Handle tapping on the result
                  close(context, repo['link']);
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = repos.where((repo) =>
        repo['title'].toString().toLowerCase().contains(query.toLowerCase()));
    return ListView(
      children: results
          .map((repo) => ListTile(
                title: Text(repo['title']),
                subtitle: Text('Uploaded by: ${repo['uploader']}'),
                onTap: () {
                  // Handle tapping on the suggestion
                  close(context, repo['link']);
                },
              ))
          .toList(),
    );
  }
}
