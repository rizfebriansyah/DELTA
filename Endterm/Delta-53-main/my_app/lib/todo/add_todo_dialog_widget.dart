import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/todo/todo.dart';
import 'package:my_app/todo/todos_provider.dart';
import 'package:my_app/todo/todo_form_widget.dart';
import 'package:my_app/services/todo.dart';

class AddTodoDialogWidget extends StatefulWidget {
  final TodosProvider p;
  AddTodoDialogWidget(this.p);

  @override
  _AddTodoDialogWidgetState createState() => _AddTodoDialogWidgetState();
}

class _AddTodoDialogWidgetState extends State<AddTodoDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';

  final BaseTodo todofirebase = new TodoFirebase();

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Todo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              TodoFormWidget(
                onChangedTitle: (title) => setState(() => this.title = title),
                onChangedDescription: (description) =>
                    setState(() => this.description = description),
                onSavedTodo: addTodo,
              ),
            ],
          ),
        ),
      );

  void addTodo() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    } else {
      final todo = Todo(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        createdTime: DateTime.now(),
      );

      // final provider = Provider.of<TodosProvider>(context, listen: false);
      // provider.addTodo(todo);
  widget.p.addTodo(todo);
      todofirebase.insertTodo(todo);
    
      Navigator.of(context).pop();
    }
  }
}
