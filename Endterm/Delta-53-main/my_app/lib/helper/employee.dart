import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  _EmployeeState createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  //get UID from database
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;
  //get email from database
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    CollectionReference employees =
        FirebaseFirestore.instance.collection('Employees');

    return Scaffold(
        body: Column(children: <Widget>[
      Expanded(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.indigoAccent,
                  Colors.indigo,
                  Colors.white
                ])),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 130,
              child: Center(
                child: FutureBuilder<DocumentSnapshot>(
                    future: employees.doc(currentUserID).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return ListView(
                          children: <Widget>[
                            CircleAvatar(
                                radius: 50,
                                child: ClipOval(
                                  child: Image.network("${data['photo']}"),
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "${data['name']} ${data['surname']}",
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 4.0),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              shadowColor: Colors.black,
                              elevation: 8.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 22.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Position",
                                            style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 24.0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "${data['position']}",
                                            style: TextStyle(
                                              fontSize: 28.0,
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(children: <Widget>[
                              new Container(
                                  color: Color(0xFFFFFFFF),
                                  child: Padding(
                                      padding: EdgeInsets.only(bottom: 25.0),
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0,
                                                  right: 25.0,
                                                  top: 25.0),
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        'Personal Information',
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          //NAME----
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0,
                                                  right: 25.0,
                                                  top: 25.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        "User ID: " +
                                                            currentUserID,
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          // USER EMAIL
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0,
                                                  right: 25.0,
                                                  top: 25.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        "Email: " +
                                                            currentUserEmail!,
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          //NAME
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0,
                                                  right: 25.0,
                                                  top: 25.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        "Full Name: " +
                                                            "${data['name']} ${data['surname']}",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0,
                                                  right: 25.0,
                                                  top: 25.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        "Date of birth: " +
                                                            "${data['birthday']}",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),

                                          //ADDRESS
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0,
                                                  right: 25.0,
                                                  top: 25.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        "Address: " +
                                                            "${data['address']}",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),

                                          //MOBILE NUMBER
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0,
                                                  right: 25.0,
                                                  top: 25.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        "Phone No: " +
                                                            "${data['phone number']}",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ],
                                      )))
                            ])
                          ],
                        );
                      }
                      return Text("loading...");
                    }),
              ),
            )),
      )
    ]));
  }
}



//   return Scaffold(
//       body: Column(children: <Widget>[
//     Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//               Colors.indigoAccent,
//               Colors.indigo,
//               Colors.white
//             ])),
//         child: Container(
//           width: double.infinity,
//           height: 350.0,
//           child: Center(
//             child: FutureBuilder<DocumentSnapshot>(
//                 future: employees.doc(currentUserID).get(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<DocumentSnapshot> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     Map<String, dynamic> data =
//                         snapshot.data!.data() as Map<String, dynamic>;
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         CircleAvatar(
//                           backgroundImage: NetworkImage(
//                             "https://actnowtraining.files.wordpress.com/2012/02/cat.jpg",
//                           ),
//                           radius: 50.0,
//                         ),
//                         SizedBox(
//                           height: 10.0,
//                         ),
//                         Text(
//                           "${data['name']} ${data['surname']}",
//                           style: TextStyle(
//                             fontSize: 25.0,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10.0,
//                         ),
//                         Card(
//                           margin: EdgeInsets.symmetric(
//                               horizontal: 20.0, vertical: 4.0),
//                           clipBehavior: Clip.antiAlias,
//                           color: Colors.white,
//                           shadowColor: Colors.black,
//                           elevation: 8.0,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8.0, vertical: 22.0),
//                             child: Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   child: Column(
//                                     children: <Widget>[
//                                       Text(
//                                         "Position",
//                                         style: TextStyle(
//                                           color: Colors.indigo,
//                                           fontSize: 24.0,
//
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 5.0,
//                                       ),
//                                       Text(
//                                         "${data['position']}",
//                                         style: TextStyle(
//                                           fontSize: 28.0,
//                                           color: Colors.redAccent,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     );
//                   }
//                   return Text("loading...");
//                 }),
//           ),
//         )),
//     Center(
//         child: FutureBuilder<DocumentSnapshot>(
//       future: employees.doc(currentUserID).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 "User ID: " + currentUserID,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w200,
//                   fontSize: 24,
//                 ),
//               ),
//               Text(
//                 "User Email: " + currentUserEmail!,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w200,
//                   fontSize: 24,
//                 ),
//               ),
//               Text(
//                 "Date of birth: " + "${data['birthday']}",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w200,
//                   fontSize: 24,
//                 ),
//               ),
//               Text(
//                 "User ID: " + currentUserID,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w200,
//                   fontSize: 24,
//                 ),
//               ),
//               Text(
//                 "User ID: " + currentUserID,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w200,
//                   fontSize: 24,
//                 ),
//               ),
//               SizedBox(height: 10),
//             ],
//           );
//         }
//
//         return Text("loading...");
//       },
//     ))
//   ]));
// }
// }

