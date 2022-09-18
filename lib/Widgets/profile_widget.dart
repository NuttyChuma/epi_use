import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:epi_use/my_globals.dart' as globals;

class ProfileWidget extends StatefulWidget {
  final bool isEdit;
  final VoidCallback onClicked;
  final Uint8List? pickedFile;
  const ProfileWidget({Key? key,this.pickedFile, required this.isEdit, required this.onClicked,}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }

  String? email;

  getSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    email = sharedPreferences.getString('email');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (email != null)
          ? Stack(
              children: [
                buildImage(),
                Positioned(bottom: 0, right: 4, child: buildEditIcon()),
              ],
            )
          : null,
    );
  }

  Widget buildImage() {
    final image = (globals.imageUrl == null)?
    NetworkImage(Gravatar(globals.email!).imageUrl()):
    NetworkImage(globals.imageUrl!);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(
            onTap: () {
              widget.onClicked();
            },
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon() {
    return buildCircle(
      child: buildCircle(
        color: Colors.blue,
        all: 8,
        child: Icon(
          widget.isEdit?Icons.add_a_photo:Icons.edit,
          size: 20.0,
          color: Colors.white,
        ),
      ), color: const Color(0xFF464667), all: 3,
    );
  }

  Widget buildCircle({
    required color,
    required double all,
    required Widget child}) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }
}
