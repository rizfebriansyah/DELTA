import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/pages/event_editing_page.dart';
import 'package:my_app/pages/event_provider.dart';
import 'package:my_app/pages/main_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventViewingPage extends StatefulWidget {
  final Meeting event;

  const EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  _EventViewingPageState createState() => _EventViewingPageState();
}

class _EventViewingPageState extends State<EventViewingPage> {

  final currentUserID = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference employees =
  FirebaseFirestore.instance.collection('Employees');

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: buildViewingActions(context, widget.event),
        ),
        body: ListView(
          padding: EdgeInsets.all(32),
          children: <Widget>[
            buildDateTime(widget.event),
            SizedBox(height: 32),
            Text(
              widget.event.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 24),
            Text(
              widget.event.description,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      );

  Widget buildDateTime(Meeting event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'All-day' : 'From: ', event.from),
        if(!event.isAllDay) buildDate('To: ', event.to),
      ],
    );
  }
  Widget buildDate(String title, DateTime date) => Row(
      children: [
        Text(title),
        Text(Utils.toDate(date) + " " + Utils.toTime(date),)
      ],

  );




  List<Widget> buildViewingActions(BuildContext context, Meeting event) =>[
    IconButton(
      icon: Icon(Icons.edit),
      onPressed: () =>
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => EventEditingPage(event: event),

            ),
          ),

    ),
    IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          final provider = Provider.of<EventProvider>(context, listen: false);
          provider.deleteEvent(event);
          int index = provider.getIndexEvent(event);
          provider.deleteEvent(event);
          employees
              .doc(currentUserID)
              .collection("DayEvents")
              .doc(index.toString())
              .delete()
              .then((value) => print("Event Deleted"))
              .catchError((error) => print("Failed to delete event: $error"));
          Navigator.of(context).pop();
        }
    ),
  ];
}