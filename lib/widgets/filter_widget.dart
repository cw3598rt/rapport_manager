import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapport_manager/providers/event_provider.dart';

class FilterWidget extends ConsumerStatefulWidget {
  FilterWidget({super.key, required this.filterLabel});

  void Function(String filter) filterLabel;

  @override
  ConsumerState<FilterWidget> createState() {
    return _FilterWidgetState();
  }
}

class _FilterWidgetState extends ConsumerState<FilterWidget> {
  String _clickedFilter = "All";

  void onTapFilters(String filter) {
    widget.filterLabel(filter);
    setState(() {
      _clickedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            onTapFilters("All");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "All",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color:
                          _clickedFilter == "All" ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
              ),
              Text(
                "${ref.watch(eventNotifierProvider)["list"].length}",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color:
                          _clickedFilter == "All" ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
              ),
            ],
          ),
          style: TextButton.styleFrom(
            fixedSize: Size(120, 50),
            overlayColor: Colors.blueAccent,
            backgroundColor: _clickedFilter == "All"
                ? Colors.blueAccent
                : Color.fromARGB(255, 205, 223, 255),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              onTapFilters("Today's tasks");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Today's tasks",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: _clickedFilter == "Today's tasks"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                      ),
                ),
                Text(
                  "${ref.watch(eventNotifierProvider)["list"].where((item) => item.date.split("/")[1] == DateTime.now().day.toString()).length}",
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: _clickedFilter == "Today's tasks"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
            style: TextButton.styleFrom(
              fixedSize: Size.fromHeight(50),
              overlayColor: Colors.blueAccent,
              backgroundColor: _clickedFilter == "Today's tasks"
                  ? Colors.blueAccent
                  : Color.fromARGB(255, 205, 223, 255),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              onTapFilters("Weekly tasks");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Weekly tasks",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: _clickedFilter == "Weekly tasks"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                      ),
                ),
                Text(
                  "${ref.watch(eventNotifierProvider)["list"].where((item) => item.date.split("/")[1] != DateTime.now().day.toString()).length}",
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: _clickedFilter == "Weekly tasks"
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
            style: TextButton.styleFrom(
              fixedSize: Size.fromHeight(50),
              overlayColor: Colors.blueAccent,
              backgroundColor: _clickedFilter == "Weekly tasks"
                  ? Colors.blueAccent
                  : Color.fromARGB(255, 205, 223, 255),
            ),
          ),
        ),
      ],
    );
  }
}
