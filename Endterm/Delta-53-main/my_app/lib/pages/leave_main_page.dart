import 'package:my_app/helper/constants.dart';

import 'leave_provider.dart';
import 'package:my_app/helper/drawer_navigation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/leave_widget.dart';
import 'package:my_app/pages/leave_editing_page.dart';
import 'package:provider/provider.dart';

class LeaveMainPage extends StatelessWidget {
  static final String title = "Leave Application Calendar";

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LeaveProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.indigo[300],
            accentColor: Colors.indigo[300],
          ),
          home: MainPage(),
        ),
      );
}

class MainPage extends StatelessWidget {
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(LeaveMainPage.title),
          centerTitle: true,
        ),
        body: LeaveWidget(),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.indigo,
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LeaveEditingPage()))),
        drawer: MyDrawer(),
      );
}

//To create a meeting inside the app
class Leave {
  final String status;
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  const Leave({
    required this.status,
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.indigo,
    this.isAllDay = true,
  });
}
