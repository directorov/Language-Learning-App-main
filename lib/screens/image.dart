import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:langapp/screens/login_page.dart';
import 'package:line_icons/line_icons.dart';

class ImageUploads extends StatefulWidget {
  final ColorScheme dync;
  final User user;
  final dphoto;
  final lang;

  // The fields should be final to meet the immutability requirement.
  const ImageUploads({
    super.key,
    required this.dync,
    required this.user,
    required this.dphoto,
    required this.lang,
  });

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}


class _ImageUploadsState extends State<ImageUploads> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  // Вы можете удалить эти переменные, так как они не используются
  // final bool _isSendingVerification = false;
  // final bool _isSigningOut = false;

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final destination = 'files/${widget.user.email!.toLowerCase().toString()}';

    try {
      final ref = storage.ref(destination).child('file/');
      await ref.putFile(_photo!);

      updateFile();
    } catch (e) {
      print('Error occurred during file upload: $e');
    }
  }

  Future updateFile() async {
    final destination = 'files/${widget.user.email}';
    final ref = storage.ref(destination).child('file/');

    try {
      String fileUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.user.email)
          .update({"avtar_url": fileUrl});
    } catch (e) {
      print('Error updating avatar URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dync.primary,
      body: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('user')
                          .doc(widget.user.email)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: Text("Loading .."));
                        }

                        if (!snapshot.hasData) {
                          return const Text("Error ..");
                        }

                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;

                        return data['avtar_url'] != null
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.height / 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(100)),
                                    child: Image.network(
                                      data['avtar_url'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.height / 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(100)),
                                    child: Container(
                                      color: widget.dync.primary,
                                      child: const Icon(Icons.camera_alt),
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: widget.dync.primaryContainer,
                      ),
                      child: const Icon(
                        LineIcons.alternatePencil,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.user.displayName.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              widget.user.email.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  // Обработать редактирование профиля
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.dync.primaryContainer,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: widget.dync.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            ProfileTile(
              dync: widget.dync,
              title: 'Settings',
              icon: LineIcons.cog,
              onPress: () {},
              endIcon: true,
            ),
            ProfileTile(
              dync: widget.dync,
              title: 'Billing Details',
              icon: LineIcons.wallet,
              onPress: () {},
              endIcon: true,
            ),
            ProfileTile(
              dync: widget.dync,
              title: 'Certification',
              icon: LineIcons.certificate,
              onPress: () {},
              endIcon: true,
            ),
            const Divider(),
            ProfileTile(
              dync: widget.dync,
              title: 'Information',
              icon: LineIcons.info,
              onPress: () {},
              endIcon: true,
            ),
            ProfileTile(
              dync: widget.dync,
              title: 'Logout',
              icon: LineIcons.alternateSignIn,
              onPress: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginPage(dync: widget.dync),
                ));
              },
              endIcon: false,
              textcolor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    required this.title,
    required this.icon,
    required this.onPress,
    required this.dync,
    this.endIcon = true,
    this.textcolor,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textcolor;
  final ColorScheme dync;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: dync.primaryContainer,
        ),
        child: Icon(
          icon,
          color: dync.primary,
        ),
      ),
      title: GestureDetector(
        onTap: onPress,
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.apply(
                color: textcolor ?? dync.primaryContainer,
              ),
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: dync.inversePrimary,
              ),
              child: Icon(
                LineIcons.angleRight,
                color: dync.primary,
              ),
            )
          : null,
    );
  }
}
