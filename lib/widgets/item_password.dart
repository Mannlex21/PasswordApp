import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/screens/add_password.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:password_manager/services/local_auth_service.dart';

class ItemPassword extends StatefulWidget {
  final PasswordModel data;
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
                builder: (context) => AddPasswordPage(data: widget.data)))
      },
      child: GestureDetector(
        onLongPress: () async {
          final key = encrypt.Key.fromUtf8('%C*F-JaNdRgUkXp2s5v8y/A?D(G+KbPe');
          final iv = encrypt.IV.fromLength(16);
          final encrypter = encrypt.Encrypter(encrypt.AES(key));
          final decrypted = encrypter.decrypt(
              encrypt.Encrypted.fromBase64(widget.data.password),
              iv: iv);
          final authenticate = await LocalAuth.authenticate();
          if (authenticate) {
            await Clipboard.setData(ClipboardData(text: decrypted));
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('No se ha copiado la contraseña'),
              duration: Duration(seconds: 1),
            ));
          }
        },
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
