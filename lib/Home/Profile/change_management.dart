import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:epi_use/my_globals.dart' as globals;
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:http/http.dart' as http;

class ChangeManagement extends StatefulWidget {
  const ChangeManagement({Key? key}) : super(key: key);

  @override
  State<ChangeManagement> createState() => _ChangeManagementState();
}

class _ChangeManagementState extends State<ChangeManagement> {
  String selected = '';

  Widget fabChild = const Text('Save');
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your New Manager'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 500,
          mainAxisExtent: 77,
        ),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 16.0),
        itemCount: globals.users!.length,
        itemBuilder: (context, index) => Card(
          child: Center(
            child: ListTile(
              selectedTileColor: Colors.grey,
              selected:
                  (selected == globals.users![index]['email']) ? true : false,
              isThreeLine: true,
              leading: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                    Gravatar(globals.users![index]['email']).imageUrl()),
              ),
              title: Text(globals.users![index]['full_name']),
              subtitle: (globals.users![index]['updatedEmail'] == null)
                  ? Text(
                      'Email: ${globals.users![index]['email']}\nWorks in: ${globals.users![index]['department']}')
                  : Text(
                      'Email: ${globals.users![index]['updatedEmail']}\nWorks in: ${globals.users![index]['department']}'),
              onTap: () {
                selected = globals.users![index]['email'];

                setState(() {});
                debugPrint(selected);
                // openDialog(index);
              },
            ),
          ),
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: uploading?null: () async {
          if (selected.isNotEmpty) {
            setState(() {
              fabChild = const CircularProgressIndicator(color: Colors.white,);
              uploading = true;
            });
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

            for (int i = 0; i < children.length; i++) {
              for (int j = 0; j < globals.users!.length; j++) {
                if (children[i]['email'] == globals.users![j]['email']) {
                  globals.users![j]['manager'] = globals.manager;
                  break;
                }
              }
            }

            for (int j = 0; j < globals.users!.length; j++) {
              if (globals.email == globals.users![j]['email']) {
                globals.users![j]['manager'] = selected;
                break;
              }
            }

            String uri = "http://192.168.7.225:5000/";
            await http.post(Uri.parse("${uri}changeManager"),
                headers: <String, String>{
                  "Accept": "application/json",
                  "Content-Type": "application/json; charset=UTF-8",
                },
                body: jsonEncode(<String, dynamic>{
                  'newList': globals.users!,
                }));
          }
          uploading = false;
          fabChild = const Text('Save');
          getUsers();
        },
        child: fabChild,
      ),
    );
  }

  getUsers() async {
    await globals.getUsers();
    debugPrint('called');
    setState(() {});
    Navigator.pop(context);
  }
}
