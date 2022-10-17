import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/helper/constants.dart';
import 'package:my_app/helper/drawer_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  CollectionReference requests =
      FirebaseFirestore.instance.collection('Employees');
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.indigo[300],
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Requests"),
        ),
        body: StreamBuilder(
            stream:
                requests.doc(currentUserID).collection("Leaves").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: snapshot.data!.docs.map((requests) {
                  return Card(
                    color: Colors.blue[100],
                    elevation: 10.0,
                    child: Container(
                      child: ListTile(
                        title: Transform.translate(
                          offset: Offset(0, 2),
                          child: Text(
                            requests['title'],
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        subtitle: Transform.translate(
                          offset: Offset(0, 4),
                          child: Text(
                            "Leave status: " + requests['status'],
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        onTap: () {
                          DateTime myDateTimeTo = requests["to"].toDate();
                          DateTime myDateTimeFrom = requests["from"].toDate();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Center(
                                        child: Text(requests['title'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ))),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          myDateTimeFrom
                                                  .toString()
                                                  .substring(0, 10) +
                                              " - " +
                                              myDateTimeTo
                                                  .toString()
                                                  .substring(0, 10),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          requests['description'],
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      RaisedButton(
                                        color: Colors.indigo[100],
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ));
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
        drawer: MyDrawer(),
      ),
    );
  }
}
