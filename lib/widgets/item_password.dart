import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/models/password_model.dart';
import 'package:password_manager/screens/form_password.dart';
import 'package:password_manager/services/local_auth_service.dart';
import 'package:password_manager/utilities/crypt.dart';
import 'package:password_manager/utilities/url.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemPassword extends StatefulWidget {
  final PasswordModel data;
  final int id;
  final VoidCallback callback;
  const ItemPassword(
      {super.key,
      required this.data,
      required this.id,
      required this.callback});

  @override
  State<ItemPassword> createState() => _ItemPasswordState();
}

class _ItemPasswordState extends State<ItemPassword> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).pushNamed('/addPassword', arguments: {
          'data': widget.data.toJson()
        }).then((value) => widget.callback())
      },
      child: GestureDetector(
        onLongPress: () async {
          final decrypted = Crypt.decryptedString(widget.data.password);
          final authenticate = await LocalAuth.authenticate();
          if (authenticate) {
            await Clipboard.setData(ClipboardData(text: decrypted));
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Se ha copiado la contraseña'),
              duration: Duration(seconds: 1),
            ));
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
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.open_in_new, size: 24),
                      onPressed: () async {
                        final encoded = UrlUtils.checkIfUrlContainPrefixHttp(
                            widget.data.url);
                        final Uri url = Uri.parse(encoded);
                        final nativeAppLaunchSucceeded = await launchUrl(
                          url,
                          mode: LaunchMode.externalNonBrowserApplication,
                        );
                        if (!nativeAppLaunchSucceeded) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.inAppWebView,
                          );
                        }
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
