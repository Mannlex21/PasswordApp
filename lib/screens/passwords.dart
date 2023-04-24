import 'package:flutter/material.dart';
import 'package:password_manager/models/password_item.dart';
import 'package:password_manager/providers/notifier.dart';
import 'package:password_manager/screens/addPassword.dart';
import 'package:password_manager/services/database.dart';
import 'package:password_manager/widgets/ItemPassword.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Password'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPasswordPage()));
              },
            ),
          ],
        ),
        body: Center(
            child: Consumer<PasswordNotifier>(builder: (context, cart, child) {
          return FutureBuilder(
              future: PasswordDatabase.instance.getAllItems(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PasswordItem>> snapshot) {
                if (snapshot.hasData) {
                  List<PasswordItem> passwordItems = snapshot.data!;
                  return passwordItems.isEmpty
                      ? const Center(
                          child: Text("No hay contraseñas guardadas"))
                      : ListView.builder(
                          itemCount: passwordItems.length,
                          itemBuilder: (context, index) {
                            return ItemPassword(
                              id: passwordItems[index].id!,
                              data: passwordItems[index],
                            );
                          },
                        );
                }

                if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return const CircularProgressIndicator();
                }
              });
        })),
      ),
    );
  }
}
