import 'package:flutter/material.dart';
import 'package:rapport_manager/models/event_detail_model.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() {
    return _SettingScreenState();
  }
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController _controller = TextEditingController();
  Set<String> _events = {...events};

  void _addEvent() {
    if (_controller.text != "") {
      events.add(_controller.text);

      setState(() {
        _events = events;
      });
    }
  }

  void _removeEvent(String event) {
    events.remove(event);

    setState(() {
      _events = events;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Text(
              "Events   ${_events.length}",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final event in _events)
                    Card(
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  event,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 108, 162, 255),
                                  child: InkWell(
                                    onTap: () {
                                      _removeEvent(event);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text(
                  "Edit your event",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    onPressed: _addEvent, child: Text("Add Event")))
          ],
        ),
      ),
    );
  }
}
