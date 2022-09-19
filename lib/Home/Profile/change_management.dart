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

  List listWithNoUser = List.from(globals.users!);

  @override
  void initState() {
    filterChildren();
    super.initState();
  }

  void filterChildren() {
    listWithNoUser = List.from(globals.users!);
    final suggestions = listWithNoUser.where((user) {
      // debugPrint('$users');
      if (user['manager'] != null) {
        final userEmail = user['email'].toLowerCase();
        final currUserEmail = globals.email!.toLowerCase();

        return userEmail != currUserEmail;
      }
      return false;
    }).toList();
    debugPrint('$listWithNoUser');
    setState(() => listWithNoUser = suggestions);
  }

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
        itemCount: listWithNoUser.length,
        itemBuilder: (context, index) => Card(
          child: Center(
            child: ListTile(
              selectedTileColor: Colors.grey,
              selected:
                  (selected == listWithNoUser[index]['email']) ? true : false,
              isThreeLine: true,
              leading: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                    Gravatar(listWithNoUser[index]['email']).imageUrl()),
              ),
              title: Text(listWithNoUser[index]['full_name']),
              subtitle: (listWithNoUser[index]['updatedEmail'] == null)
                  ? Text(
                      'Email: ${listWithNoUser[index]['email']}\nWorks in: ${listWithNoUser[index]['department']}')
                  : Text(
                      'Email: ${listWithNoUser[index]['updatedEmail']}\nWorks in: ${listWithNoUser[index]['department']}'),
              onTap: () {
                selected = listWithNoUser[index]['email'];

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

            String uri = "https://pacific-fortress-04227.herokuapp.com/";
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
