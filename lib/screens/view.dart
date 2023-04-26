import 'package:flutter/material.dart';

class ViewPage extends StatefulWidget {
  // final PasswordModel data;
  // , required this.data
  const ViewPage({super.key});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('View'));
  }
}
