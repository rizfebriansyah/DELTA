
import 'package:flutter/cupertino.dart';
import 'package:my_app/pages/leave_main_page.dart';


class LeaveProvider extends ChangeNotifier{
  final List<Leave> _leaves = [];

  List<Leave> get leaves => _leaves;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Leave> get eventsOfSelectedDate => _leaves;

  void addLeave(Leave event){
    _leaves.add(event);
    notifyListeners();
  }

  void deleteLeave(Leave event) {
    _leaves.remove(event);
    notifyListeners();
  }

  void editLeave(Leave newEvent, Leave oldEvent){
    final index = _leaves.indexOf(oldEvent);
    _leaves[index] = newEvent;
    notifyListeners();
  }

  int getIndexLeaveOld(Leave newEvent, Leave oldEvent){
    final index = _leaves.indexOf(oldEvent);
    print(index);
    return index;
  }


  int getIndexLeave(Leave newEvent){
    final index = _leaves.indexOf(newEvent);
    return index;
  }


}