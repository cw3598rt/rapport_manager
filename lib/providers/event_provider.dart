import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapport_manager/data/example.dart';
import 'package:rapport_manager/models/event_detail_model.dart';

class EventNotifier extends StateNotifier<Map<String, dynamic>> {
  EventNotifier() : super({"list": examples, "filter": "All"});

  List<dynamic> get filteredEvents {
    if (state["filter"] == "Today's tasks") {
      final newArr = [...state["list"]]
          .where((item) => item.date.day == DateTime.now().day)
          .toList();

      return newArr;
    }
    if (state["filter"] == "Weekly tasks") {
      final newArr = [...state["list"]]
          .where((item) => item.date.day != DateTime.now().day)
          .toList();

      return newArr;
    }
    return state["list"];
  }

  bool overlappedItem(EventDetail event) {
    final newArr = [...state["list"]];

    if (newArr.where((item) => item.number == event.number).length > 0) {
      return true;
    }

    return false;
  }

  void addNewEvent(EventDetail event) {
    final newArr = [...state["list"]];

    final result = overlappedItem(event);
    if (result) {
      return;
    }
    newArr.add(event);
    state["list"] = newArr;
  }

  void deleteEvent(EventDetail event) {
    final newArr = [...state["list"]];

    newArr.remove(event);

    state["list"] = newArr;
  }

  void filterLabel(String filter) {
    state["filter"] = filter;
  }
}

final eventNotifierProvider =
    StateNotifierProvider<EventNotifier, Map<String, dynamic>>(
  (ref) {
    return EventNotifier();
  },
);
