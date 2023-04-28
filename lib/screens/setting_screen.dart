import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:password_manager/providers/auth.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  io.File? image;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return Consumer(
      builder: (context, tokenInfo, _) => Scaffold(
        body: SafeArea(
          child: Container(
            color: const Color(0xFFF6F6F6),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Nombre',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/editProfile');
                              },
                              child: const Text(
                                'Edit Account',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/");
                        final auth = Provider.of<Auth>(context, listen: false);
                        auth.logout();
                      },
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: Navigator.of(context).pop,
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Widget buildSheet() {
    return makeDismissible(
      child: DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.1,
          maxChildSize: 0.7,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  profileOptionBtn(
                    title: 'View profile picture',
                    callback: (context) {
                      Navigator.of(context).pop();
                      viewPhoto();
                    },
                  ),
                  // profileOptionBtn(
                  //   title: 'Choose from library',
                  //   callback: (context) {
                  //     uploadImgFrom(source: ImageSource.gallery);
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                  // profileOptionBtn(
                  //   title: 'Take Photo',
                  //   callback: (context) {
                  //     uploadImgFrom(source: ImageSource.camera);
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                  profileOptionBtn(
                    title: 'Remove current photo',
                    callback: (context) {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  Future<Future> viewPhoto() async {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => makeDismissible(
        child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (_, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Stack(children: [
                  Positioned(
                    left: 0.0,
                    top: 0.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const CircleAvatar(
                        radius: 12.0,
                        child: Icon(
                          Icons.close,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ]),
                ]),
              );
            }),
      ),
    );
  }

  Widget profileOptionBtn(
          {required String title, required Function callback}) =>
      TextButton(
        onPressed: () => callback(context),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
      );

  Widget loadImg() {
    if (image == null) {
      return ClipOval(
        child: SizedBox.fromSize(
          size: const Size.fromRadius(35), // Image radius
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(5),
              image: const DecorationImage(
                image: AssetImage("assets/image/default-profile-image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    } else {
      return ClipOval(
        child: SizedBox.fromSize(
          size: const Size.fromRadius(35), // Image radius
          child: Image.file(
            image!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
