// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String rollNo;
  final String graduationYear;
  final String phone;
  final String loc;
  final String ind;

  EditProfilePage({
    required this.name,
    required this.email,
    required this.rollNo,
    required this.graduationYear,
    required this.phone,
    required this.loc,
    required this.ind,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _rollNoController;
  late TextEditingController _graduationYearController;
  late TextEditingController phone, loc, ind;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _rollNoController = TextEditingController(text: widget.rollNo);
    _graduationYearController =
        TextEditingController(text: widget.graduationYear);
    phone = TextEditingController(text: widget.phone);
    loc = TextEditingController(text: widget.loc);
    ind = TextEditingController(text: widget.ind);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 62, 133),
        title: Text('Edit Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              TextFormField(
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
              SizedBox(height: 20),
              TextFormField(
                controller: _rollNoController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: 'Roll No.',
                    labelText: 'Roll No.'),
              ),
              SizedBox(height: 20),
              TextFormField(
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
              SizedBox(height: 20),
              TextFormField(
                controller: phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: 'Phone No.',
                    labelText: 'Phone No.'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: loc,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: 'Location',
                    labelText: 'Location'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: ind,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: 'Industry',
                    labelText: 'Industry'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 1, 62, 133),
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  // Save changes and navigate back
                  final updatedData = {
                    'name': _nameController.text,
                    'roll_no': _rollNoController.text,
                    'graduation_year': _graduationYearController.text,
                    'phone_number': phone.text,
                    'place': loc.text,
                    'industry': ind.text,
                  };
                  // You can handle saving changes to Firestore here
                  await FirebaseFirestore.instance
                      .collection('USERS')
                      .doc(widget.email)
                      .update(updatedData);

                  Navigator.pop(context);
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
