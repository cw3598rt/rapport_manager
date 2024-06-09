import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactCardWidget extends StatefulWidget {
  ContactCardWidget({
    super.key,
    required this.contactInfo,
    required this.pickedDate,
    required this.pickedEvent,
  });

  Contact contactInfo;
  String pickedDate;
  String pickedEvent;

  @override
  State<ContactCardWidget> createState() => _ContactCardWidgetState();
}

class _ContactCardWidgetState extends State<ContactCardWidget> {
  Contact _fullContact = Contact();
  @override
  void initState() {
    super.initState();
    _fetchFullContacts();
  }

  Future<void> _fetchFullContacts() async {
    final fullContact = await FlutterContacts.getContact(widget.contactInfo.id);
    setState(() => _fullContact = fullContact!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          clipBehavior: Clip.hardEdge,
          color: Colors.blue.shade600,
          child: SizedBox(
            width: double.infinity,
            height: 300,
            child: Stack(
              children: [
                Container(
                  color: Colors.blueAccent,
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(
                    _fullContact.name.last,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final email in _fullContact.emails)
                        Text(
                          email.address,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                fontSize: 24,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      for (final phone in _fullContact.phones)
                        Text(
                          phone.number,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                fontSize: 24,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      Text(
                        _fullContact.displayName,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
