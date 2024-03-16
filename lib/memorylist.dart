// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget buildmemorylist(BuildContext context, User user) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('USERS')
        .doc(user.email)
        .collection('memories')
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      }
      if (snapshot.data!.docs.isEmpty) {
        return Center(
          child: Text('No memories found.'),
        );
      }
      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> memory = document.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(memory['content']),
          );
        }).toList(),
      );
    },
  );
}
