import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapport_manager/models/event_detail_model.dart';
import 'package:rapport_manager/providers/event_provider.dart';
import 'package:rapport_manager/screens/home_screen.dart';
import 'package:rapport_manager/widgets/contact_card_widget.dart';
import 'package:rapport_manager/widgets/new_contact_button_widget.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class NewEventScreen extends ConsumerStatefulWidget {
  NewEventScreen({super.key, this.pickedDate});

  DateTime? pickedDate;

  @override
  ConsumerState<NewEventScreen> createState() {
    return _NewTaskScreenState();
  }
}

class _NewTaskScreenState extends ConsumerState<NewEventScreen> {
  late DateTime _pickedDate;
  String _pickedEvent = events.length == 0 ? "" : events.first;
  List<Contact> _contacts = [];
  bool _permissionDenied = false;
  late SwiperController _controller;

  Future<void> _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  void onTapPickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 7),
    );
    if (pickedDate != null) {
      setState(() {
        _pickedDate = pickedDate;
      });
    }
  }

  void onTapAddContact() async {
    await FlutterContacts.openExternalInsert();
    await _fetchContacts();
  }

  @override
  void initState() {
    super.initState();
    _pickedDate =
        widget.pickedDate != null ? widget.pickedDate! : DateTime.now();
    _fetchContacts();
    _controller = SwiperController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void onTapCreateNewEvent() async {
    final currentContactInfo = _contacts[_controller.index];
    final fullContact = await FlutterContacts.getContact(currentContactInfo.id);
    final newEvent = EventDetail(
      number: fullContact!.phones.first.number,
      name: currentContactInfo.displayName,
      date: _pickedDate,
      event: _pickedEvent,
    );

    final result =
        ref.read(eventNotifierProvider.notifier).overlappedItem(newEvent);
    if (result) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            child: Column(
              children: [
                Text("Already included"),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(eventNotifierProvider.notifier).deleteEvent(ref
                        .watch(eventNotifierProvider)["list"]
                        .where((item) => item.number == newEvent.number)
                        .first);
                    ScaffoldMessenger.of(context).clearSnackBars();
                  },
                  child: Text("delete previous event"),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      ref.read(eventNotifierProvider.notifier).addNewEvent(newEvent);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Event"),
      ),
      body: !_permissionDenied
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: onTapPickDate,
                      child: SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.pickedDate != null
                                ? formatter.format(widget.pickedDate!)
                                : formatter.format(_pickedDate)),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.calendar_month_sharp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (events.length > 0)
                      DropdownButton(
                        value: _pickedEvent,
                        items: [
                          for (final event in events)
                            DropdownMenuItem(
                              child: Text(event),
                              value: event,
                            )
                        ],
                        onChanged: (value) {
                          setState(
                            () {
                              _pickedEvent = value!;
                            },
                          );
                        },
                      ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                if (_contacts.length == 0)
                  Center(
                    child: Text('No Contacts'),
                  )
                else if (_contacts.length > 0)
                  Swiper(
                    itemCount: _contacts.length,
                    itemBuilder: (context, index) {
                      return ContactCardWidget(
                        contactInfo: _contacts[index],
                        pickedDate: formatter.format(_pickedDate),
                        pickedEvent: _pickedEvent,
                      );
                    },
                    itemWidth: 350,
                    itemHeight: 350,
                    layout: SwiperLayout.STACK,
                    controller: _controller,
                    onIndexChanged: (value) {
                      widget.pickedDate = null;
                      setState(() {
                        _controller.index = value;
                        _pickedDate = DateTime.now();
                        _pickedEvent = events.first;
                      });
                    },
                  ),
                SizedBox(
                  height: 24,
                ),
                NewContactButtonWidget(addContact: onTapAddContact),
                SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTapCreateNewEvent,
                    child: Text("Create NewEvent"),
                  ),
                )
              ],
            )
          : Center(
              child: Text('Permission denied'),
            ),
    );
  }
}
