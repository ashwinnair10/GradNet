// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Yearbook extends StatefulWidget {
  Yearbook({Key? key}) : super(key: key);

  @override
  State<Yearbook> createState() => _YearbookState();
}

class _YearbookState extends State<Yearbook> {
  String? _selectedYear;
  String? _yearbookLink;
  List<String> _availableYears = [];

  @override
  void initState() {
    super.initState();
    fetchAvailableYears();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 62, 133),
        title: Text('Yearbook'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    30.0), // Adjust border radius to make it oval-shaped
                color: Colors.grey[200], // Change dropdown background color
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButton<String>(
                value: _selectedYear,
                hint: Text('Select Year'),
                onChanged: (String? year) {
                  setState(() {
                    _selectedYear = year;
                    // Fetch the yearbook link for the selected year
                    fetchYearbookLink(year);
                  });
                },
                items: _availableYears
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                // Customize dropdown button style
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16), // Change text color and font size
                icon: Icon(Icons.arrow_drop_down), // Customize dropdown icon
                isExpanded: true, // Expand dropdown to fit available width
                underline: Container(
                  // Hide the underline
                  height: 0,
                  color: Colors.transparent,
                ),
              ),
            ),
            SizedBox(height: 20),
            _yearbookLink != null
                ? Container(
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width - 200,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 236, 236, 236),
                    ),
                    child: InkWell(
                      onTap: () async {
                        Uri _url = Uri.parse(_yearbookLink as String);
                        if (await launchUrl(_url)) {
                          await launchUrl(_url);
                        } else {
                          throw 'Could not launch $_url';
                        }
                      },
                      child: Text(
                        'View YearBook',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 1, 62, 133),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  void fetchAvailableYears() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('YEARBOOKS').get();

      List<String> years = snapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        _availableYears = years;
      });
    } catch (e) {
      print('Error fetching available years: $e');
    }
  }

  void fetchYearbookLink(String? year) async {
    if (year != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('YEARBOOKS')
                .doc(year)
                .get();

        setState(() {
          _yearbookLink = snapshot.data()?['link'];
        });
      } catch (e) {
        print('Error fetching yearbook link: $e');
        setState(() {
          _yearbookLink = null;
        });
      }
    }
  }
}
