// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './eventbox.dart';

Widget buildeventslist(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('EVENTS').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      final events = snapshot.data!.docs;

      return SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        height: 350,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: events.map((event) {
              final eventData = event.data() as Map<String, dynamic>;
              return Column(
                children: [
                  buildeventbox(
                    context,
                    eventData['title'],
                    eventData['details'],
                    (eventData['date'] as Timestamp).toDate(),
                    eventData['url'],
                  ),
                  SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}
