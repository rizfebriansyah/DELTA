import 'package:flutter/cupertino.dart';
import 'package:my_app/pages/main_page.dart';
import 'package:provider/provider.dart';

class EventProvider extends ChangeNotifier{
  final List<Meeting> _events = [];

  List<Meeting> get events => _events;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Meeting> get eventsOfSelectedDate => _events;


  void addEvent(Meeting event){
    _events.add(event);
    notifyListeners();
  }

  void deleteEvent(Meeting event) {
    _events.remove(event);
    notifyListeners();
  }

  void editEvent(Meeting newEvent, Meeting oldEvent){
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    notifyListeners();
  }

  int getIndexEventOld(Meeting newEvent, Meeting oldEvent){
    final index = _events.indexOf(oldEvent);
    print(index);
    return index;
  }


  int getIndexEvent(Meeting newEvent){
    final index = _events.indexOf(newEvent);
    return index;
  }


}