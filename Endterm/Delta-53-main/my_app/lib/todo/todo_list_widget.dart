import 'package:flutter/material.dart';
import 'package:my_app/todo/todo.dart';
import 'package:provider/provider.dart';
import 'package:my_app/todo/todos_provider.dart';
import 'package:my_app/todo/todo_widget.dart';

class TodoListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
  
    return FutureBuilder<List<Todo>>(
                     future: provider.todos,

      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData && snapshot.data!.length > 0) {
       
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            separatorBuilder: (context, index) => Container(height: 8),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final todo = snapshot.data![index];

              return TodoWidget(todo: todo);
            },
          );
        } else {
               

          return Center(
              child: Text(
            'No todos.',
            style: TextStyle(fontSize: 20),
          ));
        }
      },
    );

    // return todos.isEmpty
    //     ? Center(
    //   child: Text(
    //     'No todos.',
    //     style: TextStyle(fontSize: 20),
    //   ),
    // )
    //     : ListView.separated(
    //   physics: BouncingScrollPhysics(),
    //   padding: EdgeInsets.all(16),
    //   separatorBuilder: (context, index) => Container(height: 8),
    //   itemCount: todos.length,
    //   itemBuilder: (context, index) {
    //     final todo = todos[index];

    //     return TodoWidget(todo: todo);
    //   },
    // );
  }
}
