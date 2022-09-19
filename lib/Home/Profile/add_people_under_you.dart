import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:epi_use/my_globals.dart' as globals;
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:http/http.dart' as http;

class AddPeopleUnderYou extends StatefulWidget {
  const AddPeopleUnderYou({Key? key}) : super(key: key);

  @override
  State<AddPeopleUnderYou> createState() => _AddPeopleUnderYouState();
}

class _AddPeopleUnderYouState extends State<AddPeopleUnderYou> {
  List selected = [];

  Widget fabChild = const Text('Save');
  bool uploading = false;

  @override
  void initState() {
    filterChildren();
    super.initState();
  }
  List listWithNoUser = List.from(globals.users!);
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
    debugPrint(globals.email!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select People You Want To Add Under You'),
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
                  (selected.contains(listWithNoUser[index])) ? true : false,
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
                if (!selected.contains(listWithNoUser[index])) {
                  selected.add(listWithNoUser[index]);
                } else if (selected.contains(listWithNoUser[index])) {
                  selected.remove(listWithNoUser[index]);
                }

                setState(() {});
                // debugPrint('$selected');
                // openDialog(index);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:uploading? null: () async {
          if (selected.isNotEmpty) {
            setState(() {
              fabChild = const CircularProgressIndicator(color: Colors.white,);
              uploading = true;
            });
            for(int i=0; i < selected.length; i++){
              List children = List.from(globals.users!);
              final suggestions = children.where((child) {
                debugPrint('$child');
                if (child['manager'] != null) {
                  final childManager = child['manager'].toLowerCase();
                  final manager = selected[i]['email'].toLowerCase();

                  return manager == childManager;
                }
                return false;
              }).toList();
              children = suggestions;

              for(int k = 0; k < children.length; k++){
                for (int j = 0; j < globals.users!.length; j++) {
                  if (children[k]['email']== globals.users![j]['email']) {
                    globals.users![j]['manager'] = selected[i]['manager'];
                    break;
                  }
                }
              }

              for (int j = 0; j < globals.users!.length; j++) {
                if (selected[i]['email'] == globals.users![j]['email'] && globals.users![j]['email'] != globals.users![j]['manager']) {
                  globals.users![j]['manager'] = globals.email;
                  break;
                }
              }

            }
            String uri = "https://pacific-fortress-04227.herokuapp.com/";
            await http.post(Uri.parse("${uri}addUsersUnder"),
                headers: <String, String>{
                  "Accept": "application/json",
                  "Content-Type": "application/json; charset=UTF-8",
                },
                body: jsonEncode(<String, dynamic>{
                  'newList': globals.users!,
                }));
            uploading = false;
            fabChild = const Text('Save');
            getUsers();
          }
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
