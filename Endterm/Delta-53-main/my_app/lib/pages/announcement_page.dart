import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/helper/constants.dart';
import 'package:my_app/helper/drawer_navigation.dart';

class Announce extends StatefulWidget {
  const Announce({Key? key}) : super(key: key);

  @override
  _AnnounceState createState() => _AnnounceState();
}

class _AnnounceState extends State<Announce> {
  final textControllerTitle = TextEditingController();
  final textControllerMessage = TextEditingController();
  var textTitle = TextEditingController();
  var textMessage = TextEditingController();

  CollectionReference announcements =
      FirebaseFirestore.instance.collection('Announcements');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.indigo[300],
      ),
      home: Scaffold(
        //backgroundColor: Colors.blue[100],

        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Announcement"),
        ),
        body: StreamBuilder(
          stream: announcements.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("Loading..."));
            }
            return GridView.count(
              crossAxisCount: 2,
              // padding: const EdgeInsets.all(5),
              children: snapshot.data!.docs.map((announce) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  shadowColor: Colors.indigo,
                  color: Colors.blue[100],
                  child: Container(
                      padding: EdgeInsets.all(12),
                      // child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    announce['title'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    // maxLines: 1,
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                PopupMenuButton(itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: "Edit",
                                      child: Text("Edit"),
                                    ),
                                    PopupMenuItem(
                                      value: "Delete",
                                      child: Text("Delete"),
                                    )
                                  ];
                                }, onSelected: (String value) {
                                  if (value == "Edit") {
                                    textTitle.text = announce["title"];
                                    textMessage.text = announce["message"];
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            elevation: 16,
                                            child: Container(
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: <Widget>[
                                                  SizedBox(height: 20),
                                                  Center(
                                                      child: Text(
                                                          'Update announcement')),
                                                  SizedBox(height: 20),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 14.0),
                                                      labelText: 'Title',
                                                    ),
                                                    controller: textTitle,
                                                  ),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 14.0),
                                                      labelText: 'Message',
                                                    ),
                                                    controller: textMessage,
                                                  ),
                                                  RaisedButton(
                                                    child: Text("Update"),
                                                    onPressed: () {
                                                      announce.reference
                                                          .update({
                                                        'title': textTitle.text,
                                                        'message':
                                                            textMessage.text,
                                                      });

                                                      Navigator.pop(context,
                                                          announcements);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                  if (value == "Delete") {
                                    announce.reference.delete();
                                  }
                                }),
                              ],
                            ),
                            SizedBox(height: 12),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  announce['message'],
                                ),
                              ),
                            ),
                          ]) //),
                      ),
                );
                // return Card(
                //     color: Colors.blue[100],
                //     // elevation: 8.0,
                //     shadowColor: Colors.indigo,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20)),
                //     child: Container(
                //       padding: EdgeInsets.all(12),
                //       child: SingleChildScrollView(
                //         child: ListTile(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(20.0),
                //           ),
                //           // tileColor: Colors.blue[100],
                //           //      horizontal: 20.0, vertical: 30.0),

                //           title: Row(
                //             children: [
                //               Text(
                //                 announce['title'],
                //                 style: TextStyle(
                //                   // fontSize: 14,

                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //               PopupMenuButton(itemBuilder: (context) {
                //                 return [
                //                   PopupMenuItem(
                //                     value: "Edit",
                //                     child: Text("Edit"),
                //                   ),
                //                   PopupMenuItem(
                //                     value: "Delete",
                //                     child: Text("Delete"),
                //                   )
                //                 ];
                //               }, onSelected: (String value) {
                //                 if (value == "Edit") {
                //                   textTitle.text = announce["title"];
                //                   textMessage.text = announce["message"];
                //                   showDialog(
                //                       context: context,
                //                       builder: (context) {
                //                         return Dialog(
                //                           shape: RoundedRectangleBorder(
                //                               borderRadius:
                //                                   BorderRadius.circular(40)),
                //                           elevation: 16,
                //                           child: Container(
                //                             child: ListView(
                //                               shrinkWrap: true,
                //                               children: <Widget>[
                //                                 SizedBox(height: 20),
                //                                 Center(
                //                                     child: Text(
                //                                         'Update announcement')),
                //                                 SizedBox(height: 20),
                //                                 TextField(
                //                                   decoration: InputDecoration(
                //                                     border: InputBorder.none,
                //                                     contentPadding:
                //                                         EdgeInsets.only(
                //                                             top: 14.0),
                //                                     labelText: 'Title',
                //                                   ),
                //                                   controller: textTitle,
                //                                 ),
                //                                 TextField(
                //                                   decoration: InputDecoration(
                //                                     border: InputBorder.none,
                //                                     contentPadding:
                //                                         EdgeInsets.only(
                //                                             top: 14.0),
                //                                     labelText: 'Message',
                //                                   ),
                //                                   controller: textMessage,
                //                                 ),
                //                                 RaisedButton(
                //                                   child: Text("Update"),
                //                                   onPressed: () {
                //                                     announce.reference.update({
                //                                       'title': textTitle.text,
                //                                       'message':
                //                                           textMessage.text,
                //                                     });

                //                                     Navigator.pop(
                //                                         context, announcements);
                //                                   },
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                         );
                //                       });
                //                 }
                //                 if (value == "Delete") {
                //                   announce.reference.delete();
                //                 }
                //               }),
                //             ],
                //           ),

                //           subtitle: Text(
                //             announce['message'],
                //             maxLines: 20,
                //             overflow: TextOverflow.ellipsis,
                //             softWrap: false,
                //             style: TextStyle(
                //               fontSize: 15.0,
                //               color: Colors.black87,
                //               fontWeight: FontWeight.w300,
                //             ),
                //           ),

                //           trailing: Wrap(
                //             // spacing: 12,
                //             children: <Widget>[
                //               PopupMenuButton(itemBuilder: (context) {
                //                 return [
                //                   PopupMenuItem(
                //                     value: "Edit",
                //                     child: Text("Edit"),
                //                   ),
                //                   PopupMenuItem(
                //                     value: "Delete",
                //                     child: Text("Delete"),
                //                   )
                //                 ];
                //               }, onSelected: (String value) {
                //                 if (value == "Edit") {
                //                   textTitle.text = announce["title"];
                //                   textMessage.text = announce["message"];
                //                   showDialog(
                //                       context: context,
                //                       builder: (context) {
                //                         return Dialog(
                //                           shape: RoundedRectangleBorder(
                //                               borderRadius:
                //                                   BorderRadius.circular(40)),
                //                           elevation: 16,
                //                           child: Container(
                //                             child: ListView(
                //                               shrinkWrap: true,
                //                               children: <Widget>[
                //                                 SizedBox(height: 20),
                //                                 Center(
                //                                     child: Text(
                //                                         'Update announcement')),
                //                                 SizedBox(height: 20),
                //                                 TextField(
                //                                   decoration: InputDecoration(
                //                                     border: InputBorder.none,
                //                                     contentPadding:
                //                                         EdgeInsets.only(
                //                                             top: 14.0),
                //                                     labelText: 'Title',
                //                                   ),
                //                                   controller: textTitle,
                //                                 ),
                //                                 TextField(
                //                                   decoration: InputDecoration(
                //                                     border: InputBorder.none,
                //                                     contentPadding:
                //                                         EdgeInsets.only(
                //                                             top: 14.0),
                //                                     labelText: 'Message',
                //                                   ),
                //                                   controller: textMessage,
                //                                 ),
                //                                 RaisedButton(
                //                                   child: Text("Update"),
                //                                   onPressed: () {
                //                                     announce.reference.update({
                //                                       'title': textTitle.text,
                //                                       'message':
                //                                           textMessage.text,
                //                                     });

                //                                     Navigator.pop(
                //                                         context, announcements);
                //                                   },
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                         );
                //                       });
                //                 }
                //                 if (value == "Delete") {
                //                   announce.reference.delete();
                //                 }
                //               }),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ));
              }).toList(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.indigo,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  elevation: 16,
                  child: Container(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Center(child: Text('Add new announcement')),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            labelText: 'Title',
                          ),
                          controller: textControllerTitle,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            labelText: 'Message',
                          ),
                          controller: textControllerMessage,
                        ),
                        RaisedButton(
                          child: Text("Add"),
                          onPressed: () {
                            announcements.add({
                              'title': textControllerTitle.text,
                              'message': textControllerMessage.text,
                            });
                            textControllerTitle.clear();
                            textControllerMessage.clear();
                            Navigator.pop(context, announcements);
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        drawer: MyDrawer(),
      ),
    );
  }
}
