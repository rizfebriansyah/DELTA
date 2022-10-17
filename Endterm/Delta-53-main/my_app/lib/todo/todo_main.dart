import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/todo/todo_home_page.dart';
import 'package:my_app/todo/todos_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';


class TodoMainPage extends StatelessWidget {
  static final String title = 'Todo List';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => TodosProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Color(0xFFf6f5ee),
      ),
      home: TodoHomePage(),
    ),
  );
}

