import 'package:flutter/material.dart';
import 'package:my_app/todo/todo.dart';
import 'package:provider/provider.dart';
import 'package:my_app/todo/todos_provider.dart';
import 'package:my_app/todo/todo_widget.dart';

class CompletedListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);

     
    return FutureBuilder<List<Todo>>(
                     future: provider.todosCompleted,

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
            'No completed tasks.',
            style: TextStyle(fontSize: 20),
          ));
        }
      },
    );
  }
}
