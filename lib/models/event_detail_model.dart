import 'package:intl/intl.dart';

final formatter = DateFormat.Md();

enum Events { birthDay, sayHello, recentlyPurchased, firstPurchased }

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
  Events event;
}
