import 'package:grouped_list/grouped_list.dart';
import 'package:flutter/material.dart';
import 'package:my_app/helper/constants.dart';
import 'package:my_app/helper/drawer_navigation.dart';

List _elements = [
  {
    'qns': 'How to use the Announcement page?',
    'ans':
        'The announcement is a place where employees can be notified of any new announcements. To make an announcement, press the button at the bottom right to add an announcement. Enter the title and then add your description, press the add button to have your announcement inside the page!',
    'cat': 'How to use'
  },
  {
    'qns':
        'Oh no! I wish to edit or delete the announcement! Is that possible?',
    'ans':
        'Yes it is possible! Please click the three dots at the side to edit or delete the announcement you have made and then hit update!',
    'cat': 'How to use'
  },
  {
    'qns': 'What does the calendar at the Home page do?',
    'ans':
        'The calendar at the home page lets the user (you) to know the current event on the current day. You can add an event by clicking the add button at the bottom right!',
    'cat': 'How to use'
  },
  {
    'qns': 'Who do I notify to change password?',
    'ans':
        'If you wish to change your password, please drop an email to our HR executive! The email is, david.toh@delta53.com or call 98334510!',
    'cat': 'Contact support'
  },
  {
    'qns': 'How do I make an account?',
    'ans':
        'Press the Contact Administrator at the bottom of the login page, the HR Executive will be notified to assist you!',
    'cat': 'Contact support'
  },
  {
    'qns':
        'Does the app allow me to see my leaves and pay? Or do I need to ask the HR Executive for that matter?',
    'ans':
        'We are aware of the issue and we are happy to let you know that if you click on the User Profile, you can see your leaves and payslip. Each option with just a press of button away.',
    'cat': 'How to use'
  },
];

class Faq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.indigo[300],
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('FAQ'),
        ),
        body: GroupedListView<dynamic, String>(
          elements: _elements,
          groupBy: (element) => element['cat'],
          groupComparator: (value1, value2) => value1.compareTo(value2),
          itemComparator: (item1, item2) =>
              item1['qns'].compareTo(item2['qns']),
          order: GroupedListOrder.ASC,
          useStickyGroupSeparators: true,
          groupSeparatorBuilder: (String value) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (c, element) {
            return Card(
              elevation: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                child: ListTile(
                  tileColor: Colors.blue[100],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Icon(Icons.account_circle),
                  title: Text(element['qns']),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(element['qns'], element['ans']),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        drawer: MyDrawer(),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String qns;
  final String ans;
  DetailScreen(this.qns, this.ans);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(qns),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(ans),
      ),
    );
  }
}
