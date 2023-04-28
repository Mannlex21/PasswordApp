import 'package:flutter/material.dart';
import 'package:password_manager/screens/passwords.dart';
import 'package:password_manager/screens/setting_screen.dart';
import 'package:password_manager/screens/view.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List widgetOptions = [
      const PasswordPage(),
      const SettingScreen(),
    ];

    return Consumer(
      builder: (context, tokenInfo, _) => Scaffold(
        body: widgetOptions.elementAt(_selectedIndex),
        // drawer: const MyDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Password',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          backgroundColor: const Color(0xFFF9F9F9),
          // backgroundColor: const Color(0xFFF9F9F9),
          type: BottomNavigationBarType.fixed,
          elevation: 4,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
