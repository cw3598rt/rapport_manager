import 'package:intl/intl.dart';

final formatter = DateFormat.Md();

var events = {"birthDay", "recentlyPurchased", "firstPurchased"};

class EventDetail {
  EventDetail({
    required this.id,
    required this.number,
    required this.name,
    required this.date,
    required this.event,
  });

  String id;
  String number;
  String name;
  String date;
  String event;
}
