import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  @override
  @override
  Widget build(BuildContext context) {
    // var db = FirebaseFirestore.instance;
    // final docRef = db.collection("password");
    // docRef.get().then(
    //       (res) => {
    //         res.docs.forEach((element) {
    //           print(element.data());
    //         })
    //       },
    //       onError: (e) => print("Error getting document: $e"),
    //     );
    return MaterialApp(
      theme:
          ThemeData(brightness: Brightness.dark, primaryColor: Colors.blueGrey),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Password'),
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
                    print(snapshot.data!.docs[index]);
                    return ListTile(
                      title: Text(
                        snapshot.data!.docs[index].get('name'),
                      ),
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
