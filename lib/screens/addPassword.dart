import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/models/password_model.dart';

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({super.key});

  @override
  State<AddPasswordPage> createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool passwordVisible = false;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddPasswordPage()));
          },
        ),
        title: const Text('Nuevo registro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Wrap(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.web),
                        hintText: 'Ingrese sitio web o aplicación',
                        labelText: 'Nombre',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido';
                        }
                        return null;
                      },
                    ),
                    StatefulBuilder(builder: (context, innerSetState) {
                      return TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                            icon: const Icon(Icons.password),
                            hintText: 'Ingrese contraseña',
                            labelText: 'Contraseña',
                            suffixIcon: IconButton(
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                innerSetState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo requerido';
                          }
                          return null;
                        },
                      );
                    }),
                    TextFormField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.language),
                        hintText: 'Ingrese url de sitio',
                        labelText: 'URL',
                      ),
                      validator: (value) {
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.description),
                        hintText: 'Ingrese descripción del sitio o aplicación',
                        labelText: 'Descripción',
                      ),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextButton(
                child: const Text('Guardar'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newRegister = PasswordModel(
                            nameController.text,
                            passwordController.text,
                            descriptionController.text,
                            urlController.text)
                        .toJson();
                    var db = FirebaseFirestore.instance;
                    db.collection("password").add(newRegister).then((value) {
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddPasswordPage()));
                    }).onError((error, stackTrace) => null);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
