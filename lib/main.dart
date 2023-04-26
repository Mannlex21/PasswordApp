import 'package:flutter/material.dart';
import 'package:password_manager/providers/global_notifier.dart';
import 'package:password_manager/screens/passwords.dart';
import 'package:password_manager/screens/view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalNotifier(),
      child: MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark, primaryColor: Colors.blueGrey),
        home: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ZeroScreen();
  }
}

class ZeroScreen extends StatelessWidget {
  const ZeroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BottomNavBar();
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabPages = <dynamic>[
      ChangeNotifierProvider(
        create: (context) => GlobalNotifier(),
        child: const PasswordPage(),
      ),
      const ViewPage(),
    ];

    final navBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Passwords',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Config',
      ),
    ];

    assert(tabPages.length == navBarItems.length);
    final navBar = BottomNavigationBar(
      items: navBarItems,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.orange,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        Provider.of<GlobalNotifier>(context, listen: false)
            .updatePageSelection(index);
        setState(() {
          _currentTabIndex = index;
        });
      },
    );

    return Scaffold(
      body: tabPages[_currentTabIndex],
      bottomNavigationBar: navBar,
    );
  }
}
