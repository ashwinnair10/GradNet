// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:async';
import 'package:alumniyearbook/eventbox.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';

class EventModel {
  final String title;
  final String details;
  final DateTime date;
  final String url;

  EventModel({
    required this.title,
    required this.details,
    required this.date,
    required this.url,
  });
}

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<EventModel>> getEvents() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('EVENTS').get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return EventModel(
        title: data['title'],
        details: data['details'],
        date: (data['date'] as Timestamp).toDate(),
        url: data['url'],
      );
    }).toList();
  }

  Stream<List<EventModel>> streamEvents() {
    return _firestore.collection('EVENTS').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return EventModel(
          title: data['title'],
          details: data['details'],
          date: (data['date'] as Timestamp).toDate(),
          url: data['url'],
        );
      }).toList();
    });
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Event> events = [];
  StreamSubscription<List<EventModel>>? _eventsSubscription;

  @override
  void initState() {
    super.initState();
    _eventsSubscription =
        FirebaseService().streamEvents().listen((eventModels) {
      setState(() {
        events = eventModels.map((eventModel) {
          return Event(
            child: Column(
              children: [
                SizedBox(height: 10),
                buildeventbox(
                  context,
                  eventModel.title,
                  eventModel.details,
                  eventModel.date,
                  eventModel.url,
                ),
              ],
            ),
            dateTime: CalendarDateTime(
              year: eventModel.date.year,
              month: eventModel.date.month,
              day: eventModel.date.day,
              calendarType: CalendarType.GREGORIAN,
            ),
          );
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Event Calendar',
          style: TextStyle(
              color: Color.fromARGB(255, 1, 62, 133),
              fontWeight: FontWeight.w500),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 1, 62, 133),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: EventCalendar(
        showEvents: true,
        calendarType: CalendarType.GREGORIAN,
        events: events,
        calendarOptions: CalendarOptions(
          headerMonthBackColor: Color.fromARGB(255, 208, 227, 255),
          bottomSheetBackColor: Color.fromARGB(255, 208, 227, 255),
          headerMonthElevation: 10,
          toggleViewType: true,
        ),
        headerOptions: HeaderOptions(
          headerTextColor: Color.fromARGB(255, 1, 62, 133),
          navigationColor: Color.fromARGB(255, 1, 62, 133),
          resetDateColor: Color.fromARGB(255, 1, 62, 133),
          monthStringType: MonthStringTypes.FULL,
          weekDayStringType: WeekDayStringTypes.SHORT,
          calendarIconColor: Color.fromARGB(255, 1, 62, 133),
        ),
        dayOptions: DayOptions(
          showWeekDay: true,
          unselectedTextColor: Color.fromARGB(255, 1, 62, 133),
          selectedBackgroundColor: Color.fromARGB(255, 216, 94, 37),
          selectedTextColor: Color.fromARGB(255, 208, 227, 255),
          weekDaySelectedColor: Colors.black,
          eventCounterColor: Colors.green,
          eventCounterViewType: DayEventCounterViewType.LABEL,
        ),
        eventOptions: EventOptions(
          emptyIcon: Icons.error,
          emptyIconColor: Color.fromARGB(255, 28, 28, 28),
          emptyText: 'No Event Found',
          emptyTextColor: Color.fromARGB(255, 28, 28, 28),
          loadingWidget: () {
            return CircularProgressIndicator(
              strokeWidth: 5,
            );
          },
        ),
      ),
    );
  }
}
