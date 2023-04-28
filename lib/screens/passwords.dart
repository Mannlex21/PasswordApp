import 'package:flutter/material.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/screens/form_password.dart';
import 'package:password_manager/services/database.dart';
import 'package:password_manager/widgets/item_password.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  Key _futureBuilderKey = UniqueKey();

  void _actualizar() {
    setState(() {
      _futureBuilderKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/addPassword',
                  arguments: {'data': null}).then((value) => _actualizar());
              // Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const AddPasswordPage()))
              //     .then((value) => _actualizar());
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
            key: _futureBuilderKey,
            future: PasswordDatabase.instance.getAllItems(),
            builder: (BuildContext context,
                AsyncSnapshot<List<PasswordModel>> snapshot) {
              if (snapshot.hasData) {
                List<PasswordModel> passwordItems = snapshot.data!;
                return passwordItems.isEmpty
                    ? const Center(child: Text("No hay contraseñas guardadas"))
                    : ListView.builder(
                        itemCount: passwordItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 5, right: 5),
                            child: Dismissible(
                              direction: DismissDirection.endToStart,
                              key: UniqueKey(),
                              onDismissed: (direction) async {
                                await PasswordDatabase.instance
                                    .delete(passwordItems[index].id!);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Password eliminado')));
                                _actualizar();
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.delete, color: Colors.white),
                                        Text('Desliza para eliminar',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              child: ItemPassword(
                                  id: passwordItems[index].id!,
                                  data: passwordItems[index],
                                  callback: _actualizar),
                            ),
                          );
                        },
                      );
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
