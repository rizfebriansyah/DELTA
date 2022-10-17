import 'package:my_app/pages/leave_editing_page.dart';
import 'package:my_app/pages/leave_provider.dart';
import 'package:my_app/pages/leave_main_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LeaveViewingPage extends StatefulWidget {
  final Leave event;

  const LeaveViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  _LeaveViewingPageState createState() => _LeaveViewingPageState();
}

class _LeaveViewingPageState extends State<LeaveViewingPage> {

  final currentUserID = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference leaves =
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
            const SizedBox(height: 24),
            Text(
              "Approval status: " + widget.event.status,
              style: TextStyle(color: Colors.black, fontSize: 18),
            )
          ],
        ),
      );

  Widget buildDateTime(Leave event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'All-day ' : 'From: ', event.from),
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


  List<Widget> buildViewingActions(BuildContext context, Leave event) =>[
    IconButton(
      icon: Icon(Icons.edit),
      onPressed: () =>
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LeaveEditingPage(leave: event),

            ),
          ),
    ),
    IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          final provider = Provider.of<LeaveProvider>(context, listen: false);
          int index = provider.getIndexLeave(event);
          provider.deleteLeave(event);
          leaves
              .doc(currentUserID)
              .collection("Leaves")
              .doc(index.toString())
              .delete()
              .then((value) => print("Leaves Deleted"))
              .catchError((error) => print("Failed to delete leave: $error"));
          Navigator.of(context).pop();
        }
    ),
  ];
}
