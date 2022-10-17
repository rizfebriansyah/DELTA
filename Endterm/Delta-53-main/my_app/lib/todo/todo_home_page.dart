import 'package:flutter/material.dart';
import 'package:my_app/helper/constants.dart';
import 'package:my_app/helper/constants.dart';
import 'package:my_app/helper/drawer_navigation.dart';

import 'package:my_app/todo/add_todo_dialog_widget.dart';
import 'package:my_app/todo/completed_list_widget.dart';

import 'package:my_app/todo/todo_list_widget.dart';

import 'package:my_app/todo/todo_main.dart';
import 'package:my_app/todo/todos_provider.dart';
import 'package:provider/provider.dart';

class TodoHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TodoHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TodoListWidget(),
      CompletedListWidget(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(TodoMainPage.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done, size: 28),
            label: 'Completed',
          ),
        ],
      ),
      body: tabs[selectedIndex],
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        backgroundColor: accentColor,
        onPressed: () {
          final provider = Provider.of<TodosProvider>(context, listen: false);

          showDialog(
            context: context,
            builder: (context) => AddTodoDialogWidget(provider),
            barrierDismissible: false,
          );
        },
        child: Icon(Icons.add),
      ),
      drawer: MyDrawer(),
    );
  }
}
