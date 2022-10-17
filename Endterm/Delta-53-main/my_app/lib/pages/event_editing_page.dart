import 'package:flutter/material.dart';
import 'package:my_app/helper/constants.dart';
import 'package:my_app/pages/main_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'event_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventEditingPage extends StatefulWidget {
  final Meeting? meeting;

  const EventEditingPage({
    Key? key,
    this.meeting,
    Meeting? event,
  }) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
//to validate the form - need to at least put smth in text field
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  //to select date for calender
  late DateTime fromDate;
  late DateTime toDate;
  late Color eventType;

  final currentUserID = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference employees =
      FirebaseFirestore.instance.collection('Employees');

  //set some default values to chose
  @override
  void initState() {
    super.initState();

    if (widget.meeting == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      final event = widget.meeting!;

      descriptionController.text = event.description;
      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
      eventType = event.backgroundColor;
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

  //save and close buttons
  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
            icon: Icon(Icons.done),
            label: Text('SAVE'),
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
          hintText: 'Add Meeting Title',
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: (title) =>
            title != null && title.isEmpty ? 'Title cannot be empty' : null,
        controller: titleController,
      );

  Widget buildDescription() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Description of Meeting',
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: (description) => description != null && description.isEmpty
            ? 'Please fill in description of Meeting. Cannot be left blank.'
            : null,
        controller: descriptionController,
      );

  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => buildHeader(
      header: 'Select day ',
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
      header: 'Select duration',
      child: Row(children: [
        Expanded(
          flex: 2,
          child: buildDropDownField(
            text: Utils.toTime(fromDate),
            onClicked: () => pickFromDateTime(pickDate: false),
          ),
        ),
        Expanded(
          flex: 2,
          child: buildDropDownField(
            text: Utils.toTime(toDate),
            onClicked: () => pickToDateTime(pickDate: false),
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
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
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
      final event = Meeting(
        title: titleController.text,
        description: descriptionController.text,
        from: fromDate,
        to: toDate,
        isAllDay: false,
      );
      final isEditing = widget.meeting != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        int index = provider.getIndexEventOld(event, widget.meeting!);
        provider.editEvent(event, widget.meeting!);
        employees
            .doc(currentUserID)
            .collection("DayEvents")
            .doc(index.toString())
            .update({
              'title': titleController.text,
              'description': descriptionController.text,
              'from': fromDate,
              'to': toDate
            })
            .then((value) => print("Day event Updated"))
            .catchError((error) => print("Failed to update day event: $error"));

        Navigator.of(context).pop();
      } else {
        provider.addEvent(event);
        int index = provider.getIndexEvent(event);
        employees
            .doc(currentUserID)
            .collection("DayEvents")
            .doc(index.toString())
            .set(
              {
                'title': titleController.text,
                'description': descriptionController.text,
                'from': fromDate,
                'to': toDate
              },
              SetOptions(merge: true),
            )
            .then((value) => print("Day event Added"))
            .catchError((error) => print("Failed to add day event: $error"));

        Navigator.of(context).pop();
      }
    }
  }
}

//HELPERS
class Utils {
  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return '$time';
  }
}
