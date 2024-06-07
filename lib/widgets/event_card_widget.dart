import 'package:flutter/material.dart';
import 'package:rapport_manager/models/event_detail_model.dart';
import 'package:rapport_manager/widgets/message_widget.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class EventCardWidget extends StatefulWidget {
  EventCardWidget({super.key, required this.customerInfo});

  EventDetail customerInfo;

  @override
  State<EventCardWidget> createState() {
    // TODO: implement createState
    return _ContactCardWidgetState();
  }
}

class _ContactCardWidgetState extends State<EventCardWidget> {
  bool _isFinished = false;
  bool _isOpenTextArea = false;

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
                        formatter.format(widget.customerInfo.date),
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
                      widget.customerInfo.event.name,
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
                      onWaitingProcess: () {
                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            _isFinished = true;
                          });
                        });
                      },
                      onFinish: () async {
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
        if (_isOpenTextArea) MessageWidget()
      ],
    );
  }
}
