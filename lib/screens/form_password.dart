import 'package:flutter/material.dart';
import 'package:password_manager/utilities/crypt.dart';
import '../models/password_model.dart';
import 'package:password_manager/services/database.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../services/local_auth_service.dart';

class FormPasswordPage extends StatefulWidget {
  final PasswordModel? data;
  const FormPasswordPage({super.key, this.data});

  @override
  State<FormPasswordPage> createState() => _FormPasswordPage();
}

class _FormPasswordPage extends State<FormPasswordPage> {
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
            Navigator.of(context).pop();
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
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.web),
                            hintText: 'Ingrese sitio web o aplicación',
                            labelText: 'Nombre',
                            fillColor: Colors.transparent),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo requerido';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: StatefulBuilder(builder: (context, innerSetState) {
                        return TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.password),
                              hintText: 'Ingrese contraseña',
                              labelText: 'Contraseña',
                              fillColor: Colors.transparent,
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  if (widget.data?.password != null &&
                                      !passwordVisible) {
                                    final authenticate =
                                        await LocalAuth.authenticate();
                                    if (authenticate) {
                                      innerSetState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    } else {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'No se puede visualizar contraseña'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  } else {
                                    innerSetState(() {
                                      passwordVisible = false;
                                    });
                                  }
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: urlController,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.language),
                            hintText: 'Ingrese url de sitio',
                            labelText: 'URL',
                            fillColor: Colors.transparent),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.description),
                            hintText:
                                'Ingrese descripción del sitio o aplicación',
                            labelText: 'Descripción',
                            fillColor: Colors.transparent),
                        validator: (value) {
                          return null;
                        },
                      ),
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
