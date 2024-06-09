import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rapport_manager/models/event_detail_model.dart';
import 'package:text_area/text_area.dart';

final gemini = Gemini.instance;

class MessageWidget extends StatefulWidget {
  MessageWidget(
      {super.key, required this.customerInfo, required this.saveMessage});

  EventDetail customerInfo;
  void Function(String text) saveMessage;

  @override
  State<MessageWidget> createState() {
    return _MessageWidgetState();
  }
}

class _MessageWidgetState extends State<MessageWidget> {
  TextEditingController myTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    generateMessage();
  }

  void generateMessage() async {
    var event = widget.customerInfo.event;
    var name = widget.customerInfo.name;
    var date = widget.customerInfo.date;

    var prompt =
        "first of all, you have amazing customer service skill. Could you write professional text message for the customer? customer's name is $name and text message's main content is about $event at $date. please write it politely but friendly as well. and do not put any link or phone number or any unnecessary information just focus on given information only. Additionally, if given name is not english letters please translate the whole message as given name language! and also put some emoji too";

    try {
      final response = await gemini.text(prompt);
      if (response != null) {
        myTextController.text = Markdown(
          data: response.output!,
          selectable: true,
        ).data;

        widget.saveMessage(Markdown(
          data: response.output!,
          selectable: true,
        ).data);
      }

      if (response == null) {
        throw Exception("No data");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    myTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
          GeminiResponseTypeView(
            builder: (context, child, response, loading) {
              if (response != null) {
                return TextArea(
                  borderRadius: 10,
                  borderColor: const Color(0xFFCFD6FF),
                  textEditingController: myTextController,
                  validation: true,
                  errorText: 'Please type message!',
                );
              } else {
                /// idle state
                return const Center(child: Text('Search something!'));
              }
            },
          ),
        ]),
      ),
    );
  }
}
