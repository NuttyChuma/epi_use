library grobals;

import 'dart:convert';
import 'package:http/http.dart' as http;

int globalInt = 0;
List? users;
String? username;
String? email;
String? updatedEmail;
String? department;
String? salary;
String? manager;
String? dateOfBirth;
String? empNum;
String? about;
String? imageUrl;

Future<void> getUsers() async {
  String uri = "http://192.168.7.225:5000/";
  var result = await http.get(
    Uri.parse("${uri}getUsers"),
    headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    },
  );
  List json = jsonDecode(result.body);
  users = json;
}