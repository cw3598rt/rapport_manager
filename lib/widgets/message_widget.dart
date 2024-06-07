import 'package:flutter/material.dart';
import 'package:text_area/text_area.dart';

class MessageWidget extends StatefulWidget {
  MessageWidget({super.key});
  @override
  State<MessageWidget> createState() {
    return _MessageWidgetState();
  }
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(children: [
        Text(
          "AI Generated Message",
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        SizedBox(
          height: 16,
        ),
        TextArea(
          borderRadius: 10,
          borderColor: const Color(0xFFCFD6FF),
          // textEditingController: myTextController,
          onSuffixIconPressed: () => {},
          validation: true,
          errorText: 'Please type a reason!',
        ),
      ]),
    );
  }
}
