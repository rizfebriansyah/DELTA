import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/helper/constants.dart';
import 'package:my_app/helper/drawer_navigation.dart';

import 'package:my_app/helper/employee.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.indigo[300],
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            bottom: const TabBar(
              unselectedLabelColor: Colors.indigo,
              indicatorColor: Colors.indigo,
              tabs: [
                Tab(
                  icon: Icon(Icons.list_alt_outlined),
                  text: "Work Stats",
                ),
                Tab(
                  icon: Icon(Icons.person),
                  text: "Personal data",
                ),
              ],
            ),
            title: const Text('Profile'),
          ),
          body: const TabBarView(
            children: [
              // Payslip(),
              Leaves(),
              Employee(),
            ],
          ),
          drawer: MyDrawer(),
        ),
      ),
    );
  }
}


class Leaves extends StatefulWidget {
  const Leaves({Key? key}) : super(key: key);

  @override
  _LeavesState createState() => _LeavesState();
}

class _LeavesState extends State<Leaves> {
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    CollectionReference employees =
        FirebaseFirestore.instance.collection('Employees');
    return Scaffold(
        body: Container(
            child: Center(
      child: FutureBuilder<DocumentSnapshot>(
          future: employees.doc(currentUserID).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: <Widget>[
                  Container(
                    // height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[350],
                    height: 200,
                    // width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 15.0,
                          animation: true,
                          animationDuration: 600,
                          percent: (data['leaves'] / 30),
                          center: new Text('${data['leaves']}/30',
                              style: TextStyle(fontSize: 17)),
                          progressColor: Colors.tealAccent[400],
                          backgroundColor: Colors.grey[500],
                        ),
                        Padding(
                          //the spacing between Text and Percent indicator
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                        Text('LEAVES',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold)),
                        Padding(
                          //the spacing between Text and Percent indicator
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 3,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Container(
                    color: Colors.grey[350],
                    height: 200,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('ATTENDANCE',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold)),
                        Padding(
                          //the spacing between Text and Percent indicator
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                        CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 15.0,
                          percent: (data['attendance'] / 365),
                          center: new Text(
                              ((data['attendance'] / 365 * 100)
                                      .toStringAsFixed(2) +
                                  "%"),
                              style: TextStyle(fontSize: 17)),
                          animation: true,
                          animationDuration: 600,
                          progressColor: Colors.red[200],
                          backgroundColor: Colors.grey[500],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 3,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Container(
                      height: 200,
                      color: Colors.grey[350],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text(
                              'Payslip',
                              style: TextStyle(fontSize: 50),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              '\$' + (data['payslip']).toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                        ],
                      )),
                ],
              );
            }
            return Text("loading...");
          }),
    )));
  }
}
