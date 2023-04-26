import 'package:flutter/material.dart';
import 'package:password_manager/utilities/crypt.dart';
import '../models/password_model.dart';
import 'package:password_manager/services/database.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class AddPasswordPage extends StatefulWidget {
  final PasswordModel? data;
  const AddPasswordPage({super.key, this.data});

  @override
  State<AddPasswordPage> createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  int? idPasswordItem;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (widget.data != null) {
      final key = encrypt.Key.fromUtf8('%C*F-JaNdRgUkXp2s5v8y/A?D(G+KbPe');
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter
          .decrypt(encrypt.Encrypted.fromBase64(widget.data!.password), iv: iv);
      idPasswordItem = widget.data!.id;
      nameController.value = TextEditingValue(
        text: widget.data!.name,
        selection: TextSelection.fromPosition(
          TextPosition(offset: widget.data!.name.length),
        ),
      );
      passwordController.value = TextEditingValue(
        text: decrypted,
        selection: TextSelection.fromPosition(
          TextPosition(offset: decrypted.length),
        ),
      );
      descriptionController.value = TextEditingValue(
        text: widget.data!.description,
        selection: TextSelection.fromPosition(
          TextPosition(offset: widget.data!.description.length),
        ),
      );
      urlController.value = TextEditingValue(
        text: widget.data!.url,
        selection: TextSelection.fromPosition(
          TextPosition(offset: widget.data!.url.length),
        ),
      );
    }
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
                                innerSetState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
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
                  if (idPasswordItem == null) {
                    addItem();
                  } else {
                    editItem();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addItem() async {
    if (_formKey.currentState!.validate()) {
      final encrypted = Crypt.encryptString(passwordController.text);
      final newRegister = PasswordModel(
          name: nameController.text,
          password: encrypted.base64,
          description: descriptionController.text,
          url: urlController.text);
      await PasswordDatabase.instance.insert(newRegister);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password agregado'),
        duration: Duration(seconds: 1),
      ));
      Future.delayed(const Duration(seconds: 1), () async {
        Navigator.pop(context);
      });
    }
  }

  void editItem() async {
    if (_formKey.currentState!.validate()) {
      final encrypted = Crypt.encryptString(passwordController.text);
      final editRegister = PasswordModel(
          id: idPasswordItem,
          name: nameController.text,
          password: encrypted.base64,
          description: descriptionController.text,
          url: urlController.text);
      await PasswordDatabase.instance.update(editRegister);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password editado'),
        duration: Duration(seconds: 1),
      ));
      Future.delayed(const Duration(seconds: 1), () async {
        Navigator.pop(context);
      });
    }
  }
}
