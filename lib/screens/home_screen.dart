import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications_platform_interface/src/types.dart';

import '../main.dart';
import '../provider/screenIndexProvider.dart';
import 'notification_page.dart';
import 'provider_sample_page.dart';
import 'traking_page.dart';

class HomeScreen extends StatelessWidget {
  int value;
  HomeScreen({super.key, required this.value});

  final List<dynamic> screens = [
    const ProviderSamplePage(),
    // const TrackingPage(),
    // NotificationPage(
    //   notificationAppLaunchDetails: notificationAppLaunchDetails,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    print('value: ${value}');
    final _screenindexprovider = Provider.of<ScreenIndexProvider>(context);
    int currentScreenIndex = _screenindexprovider.fetchCurrentScreenIndex;
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
        centerTitle: true,
        elevation: 4,
        shadowColor: Theme.of(context).shadowColor,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            // do something
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        elevation: 1.5,
        currentIndex: currentScreenIndex,
        onTap: (value) => _screenindexprovider.updateScreenIndex(value),
        items: [
          BottomNavigationBarItem(
              label: 'Provider',
              icon: Icon(
                  (currentScreenIndex == 0) ? Icons.home : Icons.home_outlined),
              backgroundColor: Colors.indigo),
          BottomNavigationBarItem(
            label: 'Map',
            icon: Icon(
                (currentScreenIndex == 1) ? Icons.map : Icons.map_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Notification',
            icon: Icon((currentScreenIndex == 2)
                ? Icons.notification_important
                : Icons.notification_important_outlined),
          ),
        ],
      ),
      body: screens[currentScreenIndex],
    );
  }
}
