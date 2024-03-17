// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:alumniyearbook/calendar.dart';
import 'package:flutter/material.dart';
import './button.dart';
import './eventslist.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    color: Color.fromARGB(255, 1, 36, 77),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Opacity(
                      opacity: 0.5,
                      child: Image.network(
                        'https://img.jagranjosh.com/images/2022/April/1342022/432066048_gal.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GradNet',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Connecting Graduates, Uniting Futures',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 214, 214, 214),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // Divider(
              //   thickness: 3,
              //   indent: 20,
              //   endIndent: 20,
              // ),
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Welcome to GradNet',
                    style: TextStyle(
                      color: Color.fromARGB(255, 1, 36, 77),
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildbutton(
                        context,
                        Icon(
                          Icons.book,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 30,
                        ),
                        'YearBook',
                      ),
                      buildbutton(
                        context,
                        Icon(
                          Icons.add_box,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 30,
                        ),
                        'Memories',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildbutton(
                        context,
                        Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 30,
                        ),
                        'Alumni',
                      ),
                      buildbutton(
                        context,
                        Icon(
                          Icons.people,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 30,
                        ),
                        'Connect',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildbutton(
                        context,
                        Icon(
                          Icons.cloud,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 30,
                        ),
                        'Repositories',
                      ),
                      buildbutton(
                        context,
                        Icon(
                          Icons.account_circle,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 30,
                        ),
                        'Profile',
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 3,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Upcoming Events',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 1, 62, 133),
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalendarPage(),
                        ),
                      ),
                    },
                    icon: Icon(
                      Icons.calendar_month,
                      size: 30,
                      color: Color.fromARGB(255, 1, 62, 133),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              buildeventslist(context),
            ],
          ),
        ),
      ),
    );
  }
}
