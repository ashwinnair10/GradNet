// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:alumniyearbook/connect.dart';
import 'package:alumniyearbook/memories.dart';
import 'package:alumniyearbook/profile.dart';
import 'package:alumniyearbook/alumni.dart';
import 'package:alumniyearbook/repo.dart';
import 'package:alumniyearbook/yearbook.dart';
import 'package:flutter/material.dart';

Widget buildbutton(BuildContext context, Icon icon, String title) {
  return SizedBox(
    width: 180,
    height: 80,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 1, 62, 133),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Color.fromARGB(255, 0, 62, 121),
            width: 2,
          ),
        ),
      ),
      onPressed: () => {
        if (title == 'Profile')
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            ),
          },
        if (title == 'Alumni')
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Alumni(),
              ),
            ),
          },
        if (title == 'YearBook')
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Yearbook(),
              ),
            ),
          },
        if (title == 'Connect')
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Connect(),
              ),
            ),
          },
        if (title == 'Repositories')
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Repo(),
              ),
            ),
          },
        if (title == 'Memories')
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Memories(),
              ),
            ),
          }
      },
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: 10,
            ),
            Text(title),
          ],
        ),
      ),
    ),
  );
}
