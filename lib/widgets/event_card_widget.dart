import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapport_manager/models/event_detail_model.dart';
import 'package:rapport_manager/providers/event_provider.dart';
import 'package:rapport_manager/widgets/message_widget.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

enum Share {
  whatsapp,
  whatsapp_personal,
  share_system,
}

class EventCardWidget extends ConsumerStatefulWidget {
  EventCardWidget({
    super.key,
    required this.customerInfo,
  });

  EventDetail customerInfo;

  @override
  ConsumerState<EventCardWidget> createState() {
    // TODO: implement createState
    return _ContactCardWidgetState();
  }
}

class _ContactCardWidgetState extends ConsumerState<EventCardWidget> {
  bool _isFinished = false;
  bool _isOpenTextArea = false;
  String _message = "";

  void saveMessage(String text) {
    setState(() {
      _message = text;
    });
  }

  Future<void> onButtonTap(Share share) async {
    if (_message == "") {
      return;
    }
    String msg = _message;

    String? response;
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    switch (share) {
      case Share.whatsapp:
        response = await flutterShareMe.shareToWhatsApp(msg: msg);
        break;
      case Share.share_system:
        response = await flutterShareMe.shareToSystem(msg: msg);
        break;
      case Share.whatsapp_personal:
        response = await flutterShareMe.shareWhatsAppPersonalMessage(
            message: msg, phoneNumber: widget.customerInfo.number);
        break;
    }
    debugPrint(response);
  }

  void chooseMethod() {
    if (_message == "") {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Container(
            child: Column(
              children: [
                Text("No Text Message!"),
                SizedBox(
                  height: 16,
                ),
                Text("Please Generate the message first!"),
              ],
            ),
          ),
        ),
      );
      setState(() {
        _isFinished = true;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Container(
              width: 300,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Pick your method to send message!"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: sendToWhatsApp, child: Text("Whats App")),
                      SizedBox(
                        width: 24,
                      ),
                      ElevatedButton(
                          onPressed: sendToShare, child: Text("Share"))
                    ],
                  )
                ],
              )),
        ),
      ).whenComplete(
        () => setState(() {
          _isFinished = true;
        }),
      );
    }
  }

  void sendToWhatsApp() {
    onButtonTap(Share.whatsapp);
    Navigator.of(context).pop();
  }

  void sendToShare() {
    onButtonTap(Share.share_system);
    Navigator.of(context).pop();
  }

  @override
  void didUpdateWidget(covariant EventCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _isOpenTextArea = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
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
                      widget.customerInfo.name,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          ref
                              .read(eventNotifierProvider.notifier)
                              .deleteEvent(widget.customerInfo);
                        },
                      )),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100.withOpacity(0.5),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      alignment: Alignment.center,
                      height: 50,
                      width: 60,
                      child: Text(
                        widget.customerInfo.date,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.customerInfo.event,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SwipeableButtonView(
                      buttonText: 'SLIDE TO SEND',
                      buttonWidget: Container(
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      activeColor: Colors.blueAccent,
                      isFinished: _isFinished,
                      onWaitingProcess: chooseMethod,
                      onFinish: () {
                        //TODO: For reverse ripple effect animation
                        setState(() {
                          _isFinished = false;
                        });
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isOpenTextArea = !_isOpenTextArea;
                        });
                      },
                      icon: Icon(
                        Icons.text_format,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        fixedSize: Size(60, 60),
                        iconSize: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if (_isOpenTextArea)
          MessageWidget(
              customerInfo: widget.customerInfo, saveMessage: saveMessage)
      ],
    );
  }
}
