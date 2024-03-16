// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:alumniyearbook/eventdetails.dart';
import 'package:flutter/material.dart';

Widget buildeventbox(
    BuildContext context, String title, details, DateTime date, String url) {
  return ElevatedButton(
    onPressed: () => {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetails(
              title: title, details: details, url: url, date: date),
        ),
      ),
    },
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(0),
    ),
    child: Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 235, 235, 235),
        borderRadius: BorderRadius.circular(14),
      ),
      height: 160,
      width: MediaQuery.of(context).size.width - 40,
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              height: 140,
              width: 140,
              url,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                    height: 1,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 62, 121),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  details,
                  style: TextStyle(
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 62, 121),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${date.day} / ${date.month} / ${date.year}',
                  style: TextStyle(
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 62, 121),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
