import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/providers/auth.dart';
import 'package:password_manager/providers/global_notifier.dart';
import 'package:password_manager/screens/form_password.dart';
import 'package:password_manager/screens/dashboard_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/screens/passwords.dart';
import 'package:password_manager/screens/registration_screen.dart';
import 'package:password_manager/screens/view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => GlobalNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => Auth(),
      )
    ],
    child: MaterialApp(
      themeMode: ThemeMode.dark,
      // theme: ThemeData(
      //     brightness: Brightness.dark, primaryColor: Colors.blueGrey),
      // home: const MainApp(),
      theme: FlexColorScheme.light(scheme: FlexScheme.mandyRed).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.mandyRed).toTheme,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          final auth = Provider.of<Auth>(context, listen: false);
          if (auth.isAuth) {
            switch (settings.name) {
              case '/':
                return LoginScreen(context);
              case '/addPassword':
                final Map<String, dynamic> args =
                    settings.arguments as Map<String, dynamic>;
                return FormPasswordPage(
                    data: args['data'] != null
                        ? PasswordModel.fromJson(args['data'])
                        : null);
              case '/dashboard':
                return const DashboardScreen();
              default:
                return LoginScreen(context);
            }
          } else {
            switch (settings.name) {
              case '/':
                return LoginScreen(context);
              case '/registration':
                return RegistrationScreen(context);
              default:
                return LoginScreen(context);
            }
          }
        });
      },
    ),
  ));
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
        icon: Icon(Icons.lock),
        label: 'Passwords',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    assert(tabPages.length == navBarItems.length);
    final navBar = BottomNavigationBar(
      items: navBarItems,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      // unselectedItemColor: Colors.grey,
      // selectedItemColor: Colors.orange,
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
