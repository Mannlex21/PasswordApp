import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/providers/notifier.dart';
import 'package:password_manager/screens/add_password.dart';
import 'package:password_manager/services/database.dart';
import 'package:password_manager/services/local_auth_service.dart';
import 'package:password_manager/widgets/item_password.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

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
            )
          ],
        ),
        body: Center(
            child: Consumer<PasswordNotifier>(builder: (context, cart, child) {
          return FutureBuilder(
              future: PasswordDatabase.instance.getAllItems(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PasswordModel>> snapshot) {
                if (snapshot.hasData) {
                  List<PasswordModel> passwordItems = snapshot.data!;
                  return passwordItems.isEmpty
                      ? const Center(
                          child: Text("No hay contraseñas guardadas"))
                      : ListView.builder(
                          itemCount: passwordItems.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Dismissible(
                                  direction: DismissDirection.endToStart,
                                  key: UniqueKey(),
                                  onDismissed: (direction) async {
                                    await PasswordDatabase.instance
                                        .delete(passwordItems[index].id!);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Password eliminado')));
                                    Provider.of<PasswordNotifier>(context,
                                            listen: false)
                                        .shouldRefresh();
                                  },
                                  background: Container(color: Colors.red),
                                  secondaryBackground: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Container(
                                      color: Colors.red,
                                      child: const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.delete,
                                                color: Colors.white),
                                            Text('Desliza para eliminar',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: ItemPassword(
                                    id: passwordItems[index].id!,
                                    data: passwordItems[index],
                                  )),
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
