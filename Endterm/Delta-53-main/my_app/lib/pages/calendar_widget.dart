import 'package:flutter/material.dart';
import 'package:my_app/pages/main_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:my_app/pages/event_provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:my_app/pages/event_viewing_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference employees =
        FirebaseFirestore.instance.collection('Employees');

    final provider = Provider.of<EventProvider>(context);

    if (provider.events.isEmpty) {
      print("Connected to database for main page event calendar");
      employees
          .doc(currentUserID)
          .collection("DayEvents")
          .get()
          .then((QuerySnapshot querySnapshot) {
        int counter = 0;
        querySnapshot.docs.forEach((doc) {
          DateTime myDateTimeTo = doc["to"].toDate();
          DateTime myDateTimeFrom = doc["from"].toDate();
          final event = Meeting(
            title: doc["title"],
            description: doc["description"],
            from: myDateTimeFrom,
            to: myDateTimeTo,
            isAllDay: false,
          );
          if (counter == int.parse(doc.id)) {
            employees
                .doc(currentUserID)
                .collection("DayEvents")
                .doc(counter.toString())
                .set({
              "title": doc["title"],
              "description": doc["description"],
              "from": myDateTimeFrom,
              "to": myDateTimeTo,
            });
          } else {
            employees
                .doc(currentUserID)
                .collection("DayEvents")
                .doc(counter.toString())
                .set({
              "title": doc["title"],
              "description": doc["description"],
              "from": myDateTimeFrom,
              "to": myDateTimeTo,
            });
            doc.reference.delete();
          }

          provider.events.add(event);
          counter += 1;
        });
      });
    }

    return SfCalendarTheme(
        data: SfCalendarThemeData(
        timeTextStyle: TextStyle(fontSize: 12, color: Colors.indigo),
    ),
    child: SfCalendar(
      todayHighlightColor: Colors.indigo,
        view: CalendarView.week,
        appointmentBuilder: appointmentBuilder,
        timeSlotViewSettings: TimeSlotViewSettings(
            timeInterval: Duration(hours: 1),
            timeIntervalHeight: 100,
            startHour: 7,
            endHour: 20),
        dataSource: EventDataSource(provider.events),
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.transparent,
        onTap: (details) {
          provider.setDate(details.date!);

          if (details.appointments == null) return;
          final event = details.appointments!.first;

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventViewingPage(event: event),
          ));
        }));
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first;
    print("Appointments retrieved.");
    return Container(
        width: details.bounds.width,
        height: details.bounds.height,
        decoration: BoxDecoration(
          color: event.backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            event.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Meeting> appointments) {
    this.appointments = appointments;
  }

  Meeting getEvent(int index) => appointments![index] as Meeting;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  Color getColor(int index) => getEvent(index).backgroundColor;

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;
}

