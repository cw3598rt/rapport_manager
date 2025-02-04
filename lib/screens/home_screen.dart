import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapport_manager/providers/event_provider.dart';
import 'package:rapport_manager/screens/calendar_screen.dart';
import 'package:rapport_manager/screens/newEvent_screen.dart';
import 'package:rapport_manager/screens/setting_screen.dart';
import 'package:rapport_manager/widgets/banner_widget.dart';
import 'package:rapport_manager/widgets/event_card_widget.dart';
import 'package:rapport_manager/widgets/filter_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(eventNotifierProvider.notifier).loadEvents();
  }

  void onTapTabBar(int tabIndex) {
    setState(() {
      _tabIndex = tabIndex;
    });
  }

  void onTapToNewTask() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 7),
    );
    if (pickedDate != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NewEventScreen(pickedDate: pickedDate),
        ),
      );
    }
  }

  void getFilterLabel(String filter) {
    ref.read(eventNotifierProvider.notifier).filterLabel(filter);
  }

  @override
  Widget build(BuildContext context) {
    var list = ref.watch(eventNotifierProvider);
    return Scaffold(
      appBar: _tabIndex == 0
          ? AppBar(
              toolbarHeight: 120,
              title: Container(
                child: TextButton(
                  onPressed: onTapToNewTask,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.add,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Icon(Icons.calendar_month_sharp)
                    ],
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    fixedSize: Size.fromWidth(150),
                  ),
                ),
              ),
            )
          : null,
      body: _tabIndex == 0
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    FilterWidget(filterLabel: getFilterLabel),
                    if (list["list"].length == 0)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 200, bottom: 400),
                          child: Text("No Event"),
                        ),
                      ),
                    if (ref
                            .watch(eventNotifierProvider.notifier)
                            .filteredEvents
                            .length ==
                        1)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 300),
                        child: EventCardWidget(
                          customerInfo: ref
                              .watch(eventNotifierProvider.notifier)
                              .filteredEvents
                              .first,
                        ),
                      )
                    else
                      Swiper(
                        itemCount: ref
                            .watch(eventNotifierProvider.notifier)
                            .filteredEvents
                            .length,
                        itemBuilder: (context, index) {
                          return EventCardWidget(
                            customerInfo: ref
                                .watch(eventNotifierProvider.notifier)
                                .filteredEvents[index],
                          );
                        },
                        itemWidth: 350,
                        itemHeight: 650,
                        layout: SwiperLayout.STACK,
                      ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: BannerAdWidget())
                  ],
                ),
              ),
            )
          : CalendarScreen(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          if (value == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return NewEventScreen();
                },
              ),
            );
          } else if (value == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return SettingScreen();
                },
              ),
            );
          } else {
            onTapTabBar(value);
          }
        },
        currentIndex: _tabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            label: "NewEvent",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setting",
          )
        ],
      ),
    );
  }
}
//  BannerAdWidget()