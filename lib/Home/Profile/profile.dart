import 'dart:convert';

import 'package:epi_use/Home/Profile/add_people_under_you.dart';
import 'package:epi_use/Home/Profile/change_management.dart';
import 'package:epi_use/Home/Profile/remove_people_under_you.dart';
import 'package:epi_use/Widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../LoginAndSignup/login_and_signup.dart';
import '../../my_globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'edit_profile_page.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          ProfileWidget(
            isEdit: false,
            onClicked: () async {
              debugPrint('hello');
              debugPrint('${globals.globalInt}');
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EditProfilePage()));
              setState(() {});
            },
          ),
          const SizedBox(
            height: 24,
          ),
          buildName(),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.blue)
                          )
                      )
                  ),
                  onPressed: () async{
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPeopleUnderYou()));
                    setState(() {});
                  },
                  child: Text(
                      "Add people under you".toUpperCase(),
                      style: const TextStyle(fontSize: 14)
                  )
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.blue)
                          )
                      )
                  ),
                  onPressed: () async{
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeManagement()));
                    setState(() {});
                  },
                  child: Text(
                      "Change your manager".toUpperCase(),
                      style: const TextStyle(fontSize: 14)
                  )
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.blue)
                          ),
                      ),
                  ),
                  onPressed: () async{
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => const RemovePeopleUnderYou()));
                    setState(() {});
                  },
                  child: Text(
                      "Remove people under you".toUpperCase(),
                      style: const TextStyle(fontSize: 14)
                  )
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          buildAbout(),
        ],
      ),
    );
  }

  deleteAccount() async{
    List children = List.from(globals.users!);
    final suggestions = children.where((child) {
      debugPrint('$child');
      if (child['manager'] != null) {
        final childManager = child['manager'].toLowerCase();
        final manager = globals.email!.toLowerCase();

        return manager == childManager;
      }
      return false;
    }).toList();

    children = suggestions;

    for (int i = 0; i < children.length; i++){
      for(int j = 0; j < globals.users!.length; j++){
        if(children[i]['email'] == globals.users![j]['email']){
          globals.users![j]['manager'] = globals.manager;
          break;
        }
      }
    }

    String? uid;

    for(int i = 0; i < globals.users!.length; i++){
      if(globals.email == globals.users![i]['email']){
        uid = globals.users![i]['uid'];
      }
    }

    String uri = "http://192.168.7.225:5000/";
    await http.post(Uri.parse("${uri}deleteAccount"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, dynamic>{
          'newList': globals.users!,
          'email': globals.email!,
          'uid': uid,
        }));
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    goToSignUpPage();
  }

  goToSignUpPage(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen()),
            (Route<dynamic> route) => false);
  }

  Future openDialog(){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        // backgroundColor: Colors.grey.shade100,
        title: const Text('Your Account Is Going To Be Permanently Deleted!', style: TextStyle(fontWeight: FontWeight.bold),),
        content: const Text('Are You Sure?', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          TextButton(onPressed: (){
            deleteAccount();
          }, child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),)),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold),)),
        ],
      );
    });
  }

  Widget buildName() {
    return Column(
      children: [
        Text(
          globals.username!,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        const SizedBox(
          height: 4,
        ),
        (globals.updatedEmail == null)
            ? Text(
                globals.email!,
                style: TextStyle(color: Colors.grey.shade300),
              )
            : Text(
                globals.updatedEmail!,
                style: TextStyle(color: Colors.grey.shade300),
              ),
      ],
    );
  }

  Widget buildAbout() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4),
      width: 300.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
          const SizedBox(
            height: 16,
          ),
          (globals.about != null)
              ? Text(globals.about!,
                  style: TextStyle(
                      fontSize: 16, height: 1.4, color: Colors.grey.shade100))
              : const Text(''),
        ],
      ),
    );
  }
}
