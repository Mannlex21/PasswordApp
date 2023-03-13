import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/screens/view.dart';

class ItemPassword extends StatefulWidget {
  final PasswordModel data;
  final String? keyItem;
  const ItemPassword({super.key, required this.data, required this.keyItem});

  @override
  State<ItemPassword> createState() => _ItemPasswordState();
}

class _ItemPasswordState extends State<ItemPassword> {
  var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPage(data: widget.data)))
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.name ?? '',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.data.url ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, size: 24),
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: widget.data.password));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 24),
                      onPressed: () async {
                        db
                            .collection("password")
                            .doc(widget.keyItem)
                            .delete()
                            .then(
                              (doc) => print("Document deleted"),
                              onError: (e) =>
                                  print("Error updating document $e"),
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
