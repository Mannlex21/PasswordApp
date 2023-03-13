import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/screens/addPassword.dart';
import 'package:password_manager/widgets/ItemPassword.dart';

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
          title: Text('Password'),
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
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            // inside the <> you enter the type of your stream
            stream:
                FirebaseFirestore.instance.collection('password').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ItemPassword(
                      keyItem: snapshot.data!.docs[index].id,
                      data: PasswordModel.fromJson(
                          snapshot.data!.docs[index].data()),
                    );
                  },
                );
              }
              if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
