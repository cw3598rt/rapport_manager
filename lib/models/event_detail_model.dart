import 'package:intl/intl.dart';

final formatter = DateFormat.Md();

var events = {"birthDay", "recentlyPurchased", "firstPurchased"};

class EventDetail {
  EventDetail({
    required this.number,
    required this.name,
    required this.date,
    required this.event,
  });

  String number;
  String name;
  DateTime date;
  String event;
}
