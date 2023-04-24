// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/models/password_item.dart';
import 'package:password_manager/providers/notifier.dart';
import 'package:password_manager/screens/addPassword.dart';
import 'package:password_manager/screens/view.dart';
import 'package:password_manager/services/database.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ItemPassword extends StatefulWidget {
  final PasswordItem data;
  final int id;
  const ItemPassword({super.key, required this.data, required this.id});

  @override
  State<ItemPassword> createState() => _ItemPasswordState();
}

class _ItemPasswordState extends State<ItemPassword> {
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        widget.data.url,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, size: 24),
                      onPressed: () async {
                        final key = encrypt.Key.fromUtf8(
                            '%C*F-JaNdRgUkXp2s5v8y/A?D(G+KbPe');
                        final iv = encrypt.IV.fromLength(16);
                        final encrypter = encrypt.Encrypter(encrypt.AES(key));
                        final decrypted = encrypter.decrypt(
                            encrypt.Encrypted.fromBase64(widget.data.password),
                            iv: iv);
                        await Clipboard.setData(ClipboardData(text: decrypted));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 24),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddPasswordPage(data: widget.data)));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 24),
                      onPressed: () async {
                        await PasswordDatabase.instance.delete(widget.id);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password eliminado')));
                        Provider.of<PasswordNotifier>(context, listen: false)
                            .shouldRefresh();
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
