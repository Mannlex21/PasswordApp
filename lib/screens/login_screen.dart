import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:password_manager/providers/auth.dart';
import 'package:password_manager/widgets/display_dialog_widget.dart';
import 'package:provider/provider.dart';

// const storage = FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  final BuildContext context;

  const LoginScreen(this.context, {Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String email = "";
  String password = "";
  String errorMessage = "";
  bool showPassword = false;

  late FocusNode emailFocus;
  late FocusNode passwordFocus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 35, left: 35, bottom: 10, top: 20),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // imgFuture(),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Usuario:",
                                fillColor: Colors.transparent),
                            controller: _usernameController,
                            focusNode: emailFocus,
                            onEditingComplete: () =>
                                requestFocus(context, passwordFocus),
                            textInputAction: TextInputAction.next,
                            onSaved: (value) {
                              email = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Este campo es obligatorio";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Contraseña:",
                              fillColor: Colors.transparent,
                              suffixIcon: IconButton(
                                icon: Icon(showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: !showPassword,
                            controller: _passwordController,
                            focusNode: passwordFocus,
                            onEditingComplete: () => _signIn(context),
                            onSaved: (value) {
                              password = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Este campo es obligatorio";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                errorMessage,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                            ),
                            onPressed: () => _signIn(context),
                            child: const Text('Iniciar Sesión'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("¿No estas registrado?"),
                              TextButton(
                                child: const Text("Registrarse"),
                                onPressed: () => _showRegister(context),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();

    emailFocus.dispose();
    passwordFocus.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
  }

  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamed('/registration');
  }

  void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  Future<void> _signIn(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);

    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        errorMessage = "";
      });

      var map = <String, dynamic>{};
      map['username'] = _usernameController.text;
      map['password'] = _passwordController.text;
      auth
          .login(_usernameController.text, _passwordController.text)
          .then((value) {
        if (value) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        } else {
          displayDialog(context, "An Error Occurred",
              "No account was found matching that username and password");
        }
      });
    }
  }

  Future<Widget> img(String data) async {
    var r = jsonDecode(data);
    if (r['result'] == '') {
      return Container();
    }

    final decodedBytes = base64Decode(r['result']);
    var fileImg = File("testImage.png");
    fileImg.writeAsBytesSync(decodedBytes);
    return Image.file(fileImg);
  }
}
