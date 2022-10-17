import 'package:flutter/material.dart';
import 'package:my_app/pages/leave_main_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:my_app/pages/leave_provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:my_app/pages/leave_viewing_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference leaves =
        FirebaseFirestore.instance.collection('Employees');

    final events = Provider.of<LeaveProvider>(context).leaves;
    if (events.isEmpty) {
      leaves
          .doc(currentUserID)
          .collection("Leaves")
          .get()
          .then((QuerySnapshot querySnapshot) {
        int counter = 0;
        querySnapshot.docs.forEach((doc) {
          DateTime myDateTimeTo = doc["to"].toDate();
          DateTime myDateTimeFrom = doc["from"].toDate();
          final event = Leave(
            status: doc["status"],
            title: doc["title"],
            description: doc["description"],
            from: myDateTimeFrom,
            to: myDateTimeTo,
            isAllDay: true,
          );
          if (counter ==int.parse(doc.id)){
            leaves
                .doc(currentUserID)
                .collection("Leaves")
                .doc(counter.toString())
                .set({
              "status": doc["status"],
              "title": doc["title"],
              "description": doc["description"],
              "from": myDateTimeFrom,
              "to": myDateTimeTo,
            });

          }
          else{
            leaves
                .doc(currentUserID)
                .collection("Leaves")
                .doc(counter.toString())
                .set({
              "status": doc["status"],
              "title": doc["title"],
              "description": doc["description"],
              "from": myDateTimeFrom,
              "to": myDateTimeTo,
            });
            doc.reference.delete();
          }

          events.add(event);
          counter += 1;

        });
      });
    }

    return SfCalendar(
        view: CalendarView.month,
        dataSource: EventDataSource(events),
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.indigo,
        onLongPress: (details) {
          final provider = Provider.of<LeaveProvider>(context, listen: false);
          provider.setDate(details.date!);

          showModalBottomSheet(
            context: context,
            builder: (context) => TasksWidget(),
          );
        });
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Leave> appointments) {
    this.appointments = appointments;
  }

  Leave getEvent(int index) => appointments![index] as Leave;

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

//Task Widget

class TasksWidget extends StatefulWidget {
  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeaveProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          'No leaves found',
          style: TextStyle(color: Colors.grey, fontSize: 30),
        ),
      );
    }
    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: TextStyle(fontSize: 17, color: Colors.deepPurple),
      ),
      child: SfCalendar(
        view: CalendarView.timelineDay,
        dataSource: EventDataSource(provider.leaves),
        initialDisplayDate: provider.selectedDate,
        appointmentBuilder: appointmentBuilder,
        headerHeight: 0,
        onTap: (details) {
          if (details.appointments == null) return;
          final event = details.appointments!.first;

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LeaveViewingPage(event: event),
          ));
        },
        todayHighlightColor: Colors.red,
        selectionDecoration: BoxDecoration(
          color: Colors.pink.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first;

    return Container(
        width: details.bounds.width,
        height: details.bounds.height,
        decoration: BoxDecoration(
          color: event.backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Center(
          child: Text(
            event.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}
