import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:epi_use/my_globals.dart' as globals;
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:http/http.dart' as http;

class RemovePeopleUnderYou extends StatefulWidget {
  const RemovePeopleUnderYou({Key? key}) : super(key: key);

  @override
  State<RemovePeopleUnderYou> createState() => _RemovePeopleUnderYouState();
}

class _RemovePeopleUnderYouState extends State<RemovePeopleUnderYou> {
  @override
  void initState() {
    filterChildren();
    super.initState();
  }

  List children = List.from(globals.users!);

  void filterChildren() {
    children = List.from(globals.users!);
    final suggestions = children.where((child) {
      debugPrint('$child');
      if (child['manager'] != null) {
        final childManager = child['manager'].toLowerCase();
        final manager = globals.email!.toLowerCase();

        return manager == childManager;
      }
      return false;
    }).toList();

    setState(() => children = suggestions);
  }

  List selected = [];

  Widget fabChild = const Text('Save');
  bool disableFab = false;

  @override
  Widget build(BuildContext context) {
    debugPrint(globals.email!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select People You Want To Remove Under You'),
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
        itemCount: children.length,
        itemBuilder: (context, index) => Card(
          child: Center(
            child: ListTile(
              selectedTileColor: Colors.grey,
              selected: (selected.contains(children[index])) ? true : false,
              isThreeLine: true,
              leading: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    NetworkImage(Gravatar(children[index]['email']).imageUrl()),
              ),
              title: Text(children[index]['full_name']),
              subtitle: (children[index]['updatedEmail'] == null)
                  ? Text(
                      'Email: ${children[index]['email']}\nWorks in: ${children[index]['department']}')
                  : Text(
                      'Email: ${children[index]['updatedEmail']}\nWorks in: ${children[index]['department']}'),
              onTap: () {
                if (!selected.contains(children[index])) {
                  selected.add(children[index]);
                } else if (selected.contains(children[index])) {
                  selected.remove(children[index]);
                }

                setState(() {});
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: disableFab?null: () async {
          if (selected.isNotEmpty) {
            setState(() {
              fabChild = const CircularProgressIndicator(color: Colors.white,);
              disableFab = true;
            });
            for (int i = 0; i < selected.length; i++) {
              for (int j = 0; j < globals.users!.length; j++){
                final manager = selected[i]['email'].toLowerCase();
                final childManager = globals.users![j]['manager'].toLowerCase();

                if(manager == childManager){
                  globals.users![j]['manager'] = globals.email!;
                }
              }
              while(true){
                Random random = Random();
                int randomNumber = random.nextInt(globals.users!.length);
                if(globals.users![randomNumber]['email'] != globals.email!){
                  for(int j = 0; j < globals.users!.length; j++){
                    if(selected[i]['email'] == globals.users![j]['email']){
                      globals.users![j]['manager'] = globals.users![randomNumber]['email'];
                      break;
                    }
                  }
                  break;
                }
              }
            }

            String uri = "https://pacific-fortress-04227.herokuapp.com/";
            await http.post(Uri.parse("${uri}removeUsersUnder"),
                headers: <String, String>{
                  "Accept": "application/json",
                  "Content-Type": "application/json; charset=UTF-8",
                },
                body: jsonEncode(<String, dynamic>{
                  'newList': globals.users!,
                }));
            getUsers();
          }
          disableFab = false;
          fabChild = const Text('Save');
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
