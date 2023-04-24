import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:password_manager/models/password_item.dart';
import 'package:password_manager/screens/addPassword.dart';

class ViewPage extends StatefulWidget {
  final PasswordItem data;
  const ViewPage({super.key, required this.data});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
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
        title: const Text('Details'),
      ),
      body: const Center(child: Text('View')),
    );
  }
}
