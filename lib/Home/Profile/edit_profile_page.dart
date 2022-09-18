import 'dart:convert';
import 'package:epi_use/Widgets/textfield_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:epi_use/my_globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  late String? updatedName = globals.username!;
  late String? updatedEmail = globals.email!;
  late String? updatedAbout = globals.about!;
  late String? updatedEmployeeNumber = globals.empNum!;
  late String? updatedRole = globals.department!;
  late String? updatedSalary = globals.salary!;

  pickImage() async {
    FilePickerResult? img = await FilePicker.platform.pickFiles();
    if (img != null) {
      setState((){
        uploading = true;
      });

      Uint8List? file = img.files.first.bytes;
      String fileName = img.files.first.name;

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );

      UploadTask task = FirebaseStorage.instance
          .ref()
          .child('files/$fileName/')
          .putData(file!, metadata);

      task.whenComplete(() async {
        final storageRef = FirebaseStorage.instance.ref();
        String imageUrl =
            await storageRef.child('files/$fileName/').getDownloadURL();
        String uri = "http://192.168.7.225:5000/";
        await http.post(Uri.parse("${uri}addUserImage"),
            headers: <String, String>{
              "Accept": "application/json",
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: jsonEncode(<String, String>{
              "email": globals.email!,
              "imageUrl": imageUrl,
            }));
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('imageUrl', imageUrl);
        globals.imageUrl = imageUrl;
        await globals.getUsers();
        setState(() { uploading = false;});
        debugPrint(imageUrl);
      });
    }
  }

  Widget fabChild = const Text('Save');
  bool uploading = false;
  bool disableFab = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF464667),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: (globals.email != null)
                ? Stack(
                    children: [
                      buildImage(),
                      Positioned(bottom: 0, right: 4, child: buildEditIcon()),
                    ],
                  )
                : null,
          ),
          TextFieldWidget(
            label: 'Full Name',
            text: globals.username!,
            onChanged: (name) {
              updatedName = name;
            },
          ),
          (globals.username != null)
              ? TextFieldWidget(
                  label: 'Email',
                  text: (globals.updatedEmail == null)
                      ? globals.email!
                      : globals.updatedEmail!,
                  onChanged: (email) {
                    updatedEmail = email;
                  },
                )
              : const Text(''),
          TextFieldWidget(
            label: 'Employee Number',
            text: globals.empNum!,
            onChanged: (name) {
              updatedEmployeeNumber = name;
            },
          ),
          TextFieldWidget(
            label: 'Role',
            text: globals.department!,
            onChanged: (name) {
              updatedRole = name;
            },
          ),
          TextFieldWidget(
            label: 'Salary',
            text: globals.salary!,
            onChanged: (name) {
              updatedSalary = name;
            },
          ),
          (globals.username != null)
              ? TextFieldWidget(
                  label: 'About',
                  text: (globals.about != null) ? globals.about! : '',
                  maxLines: 5,
                  onChanged: (about) {
                    updatedAbout = about;
                  },
                )
              : const Text(''),
          const SizedBox(height: 300.0,)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        enableFeedback: false,
        onPressed: disableFab?null: () async {
          setState(() {
            fabChild = const CircularProgressIndicator(color: Colors.white,);
            disableFab = true;
          });
          String uri = "http://192.168.7.225:5000/";
          debugPrint(updatedName!);
          debugPrint(updatedEmail!);
          debugPrint(updatedAbout!);
          await http.post(Uri.parse("${uri}updateUserInfo"),
              headers: <String, String>{
                "Accept": "application/json",
                "Content-Type": "application/json; charset=UTF-8",
              },
              body: jsonEncode(<String, String>{
                'username': updatedName!,
                "email": updatedEmail!,
                "currentEmail": globals.email!,
                'about': updatedAbout!,
                'empNum': updatedEmployeeNumber!,
                'role': updatedRole!,
                'salary': updatedSalary!,
              }));

          await globals.getUsers();
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString('updatedEmail', updatedEmail!);
          sharedPreferences.setString('about', updatedAbout!);
          sharedPreferences.setString('username', updatedName!);
          sharedPreferences.setString('empNum', updatedEmployeeNumber!);
          sharedPreferences.setString('department', updatedRole!);
          sharedPreferences.setString('salary', updatedSalary!);
          globals.updatedEmail = updatedEmail;
          globals.about = updatedAbout;
          globals.username = updatedName;
          globals.empNum = updatedEmployeeNumber;
          globals.department = updatedRole;
          globals.salary = updatedSalary;
          Navigator.pop(context);
          disableFab = false;
          fabChild = const Text('Save');
        },
        // backgroundColor: Colors.green,
        child: fabChild,
      ),
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
          child: (!uploading)? InkWell(
            onTap: () {
              pickImage();
            },
          ): const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget buildEditIcon() {
    return buildCircle(
      child: buildCircle(
        color: Colors.blue,
        all: 8,
        child: const Icon(
          Icons.add_a_photo,
          size: 20.0,
          color: Colors.white,
        ),
      ),
      color: const Color(0xFF464667),
      all: 3,
    );
  }

  Widget buildCircle(
      {required color, required double all, required Widget child}) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }
}
