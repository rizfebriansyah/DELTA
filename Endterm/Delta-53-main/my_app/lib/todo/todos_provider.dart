import 'package:flutter/cupertino.dart';
import 'package:my_app/todo/todo.dart';
import 'package:my_app/services/todo.dart';

class TodosProvider extends ChangeNotifier {
  final BaseTodo todofirebase = new TodoFirebase();
  List<Todo> _todos = [
    Todo(
      createdTime: DateTime.now(),
      title: 'Project Proposal 🐕',
      description: '''- Generate ideas
- Brainstorm
- Gather feedback from teammates
- Come up with a plan and tasks will be designated accordingly''',
      id: '',
    ),
    Todo(
      createdTime: DateTime.now(),
      title: 'Plan a course to improve employees\' skills',
      description: '''- Find a skill which is suitable for the company
- Garner feedback from employees
- Find a suitable method to conduct these courses''',
      id: '',
    ),
    Todo(
      createdTime: DateTime.now(),
      title: 'Grab lunch with Miller 😋',
      id: '',
    ),
    Todo(
      createdTime: DateTime.now(),
      title: 'Plan wife\'s birthday party 🎉🥳',
      id: '',
    ),
  ];

  Future<List<Todo>> get todos async {
    _todos = await todofirebase.retrieveTodo();

    return _todos.where((todo) => todo.isDone == false).toList();
  }

  Future<List<Todo>> get todosCompleted async {
    _todos = await todofirebase.retrieveTodo();

    return _todos.where((todo) => todo.isDone == true).toList();
  }

  void addTodo(Todo todo) {
    _todos.add(todo);

    notifyListeners();
  }

  void removeTodo(Todo todo) {
    todofirebase.removeTodo(todo);

    _todos.remove(todo);
    
    notifyListeners();
  }

  bool toggleTodoStatus(Todo todo) {

    todo.isDone = !todo.isDone;
    todofirebase.updateTodo(todo);

    notifyListeners();

    return todo.isDone;
  }

  void updateTodo(Todo todo, String title, String description) {
    todo.title = title;
    todo.description = description;
    todofirebase.updateTodo(todo);

    notifyListeners();
  }
}
