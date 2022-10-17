import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/todo/todo.dart';

FirebaseFirestore databaseReference = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

abstract class BaseTodo {
  Future<List<Todo>> retrieveTodo();
  Future insertTodo(Todo todo);
  Future updateTodo(Todo todo);
  Future removeTodo(Todo todo);
}

class TodoFirebase implements BaseTodo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<List<Todo>> retrieveTodo() async {
    var ref = await databaseReference.collection("Employees").doc(_auth.currentUser!.uid).collection("MyTodos").get();

    List<Todo> todos = [];
    ref.docs.forEach((element) {
      var data = element.data();
      if (data['user'] == _auth.currentUser!.uid) {
        var t = new Todo(
            createdTime: DateTime.parse(data['createdTime']),
            id: element.id,
            title: data['title'],
            isDone: data["isDone"] == "true" ? true : false,
            description: data['description']);
        todos.add(t);
      }
    });

    return todos;
  }

  Future removeTodo(Todo todo) async {
    var ref = await databaseReference.collection("Employees").doc(_auth.currentUser!.uid).collection("MyTodos");
    ref.doc(todo.id).delete();
  }

  Future insertTodo(Todo todo) async {
    var ref = await databaseReference.collection("Employees").doc(_auth.currentUser!.uid).collection("MyTodos");

    ref.add({
      "id": todo.id,
      "title": todo.title,
      "description": todo.description,
      "createdTime": todo.createdTime.toString(),
      "user": _auth.currentUser!.uid,
      "isDone":todo.isDone.toString(),
    });
  }

  Future updateTodo(Todo todo) async {
    var ref = await databaseReference.collection("Employees").doc(_auth.currentUser!.uid).collection("MyTodos");
    ref.doc(todo.id).update({
      "id": todo.id,
      "title": todo.title,
      "description": todo.description,
      "createdTime": todo.createdTime.toString(),
      "user": _auth.currentUser!.uid,
      "isDone":todo.isDone.toString(),

    });
  }
}
