import 'package:my_app/helper/constants.dart';
import 'package:provider/provider.dart';
import 'leave_provider.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/leave_main_page.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaveEditingPage extends StatefulWidget {
  final Leave? leave;

  const LeaveEditingPage({
    Key? key,
    this.leave,
    Leave? event,
  }) : super(key: key);

  @override
  _LeaveEditingPageState createState() => _LeaveEditingPageState();
}

class _LeaveEditingPageState extends State<LeaveEditingPage> {
  //will grab database info relating to the logged in user
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;

  //validation purposes - a must to put in the title
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  //will display the date and time and can select the desired date/time
  late DateTime fromDate;
  late DateTime toDate;

  CollectionReference leaves =
      FirebaseFirestore.instance.collection('Employees');

  //to initiate the date with some values
  @override
  void initState() {
    super.initState();

    if (widget.leave == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 3));
    } else {
      final event = widget.leave!;

      descriptionController.text = event.description;
      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: CloseButton(),
          actions: buildEditingActions(),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildTitle(),
                    SizedBox(height: 12),
                    buildDateTimePickers(),
                    SizedBox(height: 12),
                    buildDescription(),
                  ],
                ))));
  }

  //to give a function to both save and close buttons
  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
            icon: Icon(Icons.done),
            label: Text('SUBMIT'),
            onPressed: saveForm,
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ))
      ];

  //build the title
  Widget buildTitle() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText:
              'Type of Leave Request (Annual, Casual, Sick, Maternity/Paternity, Marriage, Compensatory Off, etc)',
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: (title) => title != null && title.isEmpty
            ? 'Please fill in TYPE of LEAVE. Cannot be left blank.'
            : null,
        controller: titleController,
      );

  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildDescription() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Description of Leave',
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: (description) => description != null && description.isEmpty
            ? 'Please fill in description of Leave. Cannot be left blank.'
            : null,
        controller: descriptionController,
      );

  Widget buildFrom() => buildHeader(
      header: 'FROM',
      child: Row(children: [
        Expanded(
          flex: 2,
          child: buildDropDownField(
            text: Utils.toDate(fromDate),
            onClicked: () => pickFromDateTime(pickDate: true),
          ),
        ),
      ]));

  Widget buildTo() => buildHeader(
      header: 'TO',
      child: Row(children: [
        Expanded(
          flex: 2,
          child: buildDropDownField(
            text: Utils.toDate(toDate),
            onClicked: () => pickToDateTime(pickDate: true),
          ),
        ),
      ]));

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    if (date == null) return;

    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2016, 7),
        lastDate: DateTime(2100),
      );
      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Widget buildDropDownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
          child
        ],
      );

  //for the save button
  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final event = Leave(
        status: "Pending",
        title: titleController.text,
        description: descriptionController.text,
        from: fromDate,
        to: toDate,
        isAllDay: true,
      );
      final isEditing = widget.leave != null;
      final provider = Provider.of<LeaveProvider>(context, listen: false);

      if (isEditing) {
        int index = provider.getIndexLeaveOld(event, widget.leave!);
        provider.editLeave(event, widget.leave!);
        leaves
            .doc(currentUserID)
            .collection("Leaves")
            .doc(index.toString())
            .update({
              'status': event.status,
              'title': titleController.text,
              'description': descriptionController.text,
              'from': fromDate,
              'to': toDate
            })
            .then((value) => print("Leaves Updated"))
            .catchError((error) => print("Failed to update leave: $error"));
        Navigator.of(context).pop();
      } else {
        provider.addLeave(event);
        int index = provider.getIndexLeave(event);
        leaves
            .doc(currentUserID)
            .collection("Leaves")
            .doc(index.toString())
            .set(
              {
                "status": "Pending",
                'title': titleController.text,
                'description': descriptionController.text,
                'from': fromDate,
                'to': toDate
              },
              SetOptions(merge: true),
            )
            .then((value) => print("Leaves Added"))
            .catchError((error) => print("Failed to add leave: $error"));

        Navigator.of(context).pop();
      }
    }
  }
}

//HELPER
class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return '$time';
  }
}
