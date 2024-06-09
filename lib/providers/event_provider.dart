import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapport_manager/models/event_detail_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDB() async {
  var databasesPath = await sql.getDatabasesPath();

  String dbPath = path.join(databasesPath, 'event.db');

  var db = await sql.openDatabase(dbPath, onCreate: (db, version) async {
    await db.execute(
        "CREATE TABLE events(id TEXT PRIMARY KEY, eventid TEXT, name TEXT, number TEXT, event TEXT, date TEXT)");
  }, version: 1);

  return db;
}

class EventNotifier extends StateNotifier<Map<String, dynamic>> {
  EventNotifier() : super({"list": [], "filter": "All"});

  List<dynamic> get filteredEvents {
    if (state["filter"] == "Today's tasks") {
      final newArr = [...state["list"]]
          .where((item) =>
              item.date.split("/")[1] == DateTime.now().day.toString())
          .toList();

      return newArr;
    }
    if (state["filter"] == "Weekly tasks") {
      final newArr = [...state["list"]]
          .where((item) =>
              item.date.split("/")[1] != DateTime.now().day.toString())
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

  void addNewEvent(EventDetail event) async {
    final newArr = [...state["list"]];

    final result = overlappedItem(event);
    if (result) {
      return;
    }
    newArr.add(event);

    var db = await _getDB();

    await db.insert("events", {
      "eventid": event.id,
      "name": event.name,
      "number": event.number,
      "event": event.event,
      "date": event.date,
    });

    state = {
      "list": [...newArr],
      "filter": "All"
    };
  }

  void loadEvents() async {
    var db = await _getDB();

    var result = await db.query("events");

    state = {
      "list": result
          .map((row) => EventDetail(
              id: row["eventid"] as String,
              number: row["number"] as String,
              name: row['name'] as String,
              date: row['date'] as String,
              event: row['event'] as String))
          .toList(),
      "filter": "All"
    };
  }

  void deleteEvent(EventDetail event) async {
    final newArr = [...state["list"]];

    newArr.remove(event);

    var db = await _getDB();
    await db.delete("events", where: 'eventid = ?', whereArgs: [event.id]);

    state = {
      "list": [...newArr],
      "filter": "All"
    };
  }

  void filterLabel(String filter) {
    state = {
      "list": [...state["list"]],
      "filter": filter
    };
  }
}

final eventNotifierProvider =
    StateNotifierProvider<EventNotifier, Map<String, dynamic>>(
  (ref) {
    return EventNotifier();
  },
);
