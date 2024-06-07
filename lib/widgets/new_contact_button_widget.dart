import 'package:flutter/material.dart';

class NewContactButtonWidget extends StatelessWidget {
  NewContactButtonWidget({super.key, required this.addContact});

  void Function() addContact;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Colors.blue.shade600,
      child: InkWell(
        onTap: addContact,
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
                  "New Contact",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
