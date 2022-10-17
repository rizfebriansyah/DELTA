import 'package:flutter/material.dart';
import 'package:my_app/pages/announcement_page.dart';
import 'package:my_app/pages/logout_page.dart';
import 'package:my_app/pages/main_page.dart';
import 'package:my_app/pages/stats_page.dart';
import "package:my_app/pages/faq_page.dart";
import 'package:my_app/pages/leave_main_page.dart';
import 'package:my_app/pages/requests_page.dart';
import 'package:my_app/todo/todo_main.dart';
//import 'package:my_app/pages/leaves_page.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigoAccent),
            child: Text("View"),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.indigo[300], size: 24.0),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CalendarMainPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.email, color: Colors.indigo[300], size: 22.0),
            title: const Text('Request'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Requests()));
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today_outlined,
                color: Colors.indigo[300], size: 22.0),
            title: const Text('Leaves'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              if (context.widget == MyDrawer()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LeaveMainPage()),
                );
              }
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => Calendar()));
            },
          ),
          ListTile(
            leading: Icon(Icons.assessment_outlined,
                color: Colors.indigo[300], size: 24.0),
            title: const Text('User Profile'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Stats()));
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory_rounded,
                color: Colors.indigo[300], size: 24.0),
            title: const Text('To-Do List'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => TodoMainPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.announcement_outlined,
                color: Colors.indigo[300], size: 24.0),
            title: const Text('Announcement'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Announce()));
            },
          ),
          ListTile(
              leading: Icon(Icons.help, color: Colors.indigo[300], size: 24.0),
              title: const Text('FAQ'),
              onTap: () {
                if (context.widget == Faq()) {
                  Navigator.pop(context);
                }
                //Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Faq()));
              }),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.indigo[300], size: 24.0),
            title: const Text('Log Out'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) =>
                      LogoutOverlay()));
            },
          ),
        ],
      ),
    );
  }
}
