import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../my_globals.dart' as globals;

import '../Home/app.dart';

// Uri to the API
String uri = "https://pacific-fortress-04227.herokuapp.com/";

// data to send
String? nUsername, nEmail, nDepartment, nSalary, nManager, nDateOfBirth, nEmpNum, imageUrl, about, updatedEmail;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }

  getSharedPreferences() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    globals.email = sharedPreferences.getString('email');
    globals.username = sharedPreferences.getString('username');
    globals.department = sharedPreferences.getString('department');
    globals.salary = sharedPreferences.getString('salary');
    globals.manager = sharedPreferences.getString('manager');
    globals.dateOfBirth = sharedPreferences.getString('dateOfBirth');
    globals.empNum = sharedPreferences.getString('empNum');
    globals.updatedEmail = sharedPreferences.getString('updatedEmail');
    globals.about = sharedPreferences.getString('about');
    globals.imageUrl = sharedPreferences.getString('imageUrl');
    // debugPrint('${globals.email}');
    if(globals.email != null && globals.email != ''){
      navigateToTreeViewPage();
    }
  }
  navigateToTreeViewPage(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SidebarXExampleApp()));
  }

  Duration get loginTime => const Duration(milliseconds: 2250);

  Duration get duration => const Duration(milliseconds: 1);

  Future<String?> _authUser(LoginData data) async {
    var result = await http.post(Uri.parse("${uri}login"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, String>{
          "email": data.name,
          "password": data.password,
        }));

    try{
      var json = await jsonDecode(result.body);
      nUsername = json['full_name'];
      nEmail = data.name;
      nDepartment = json['department'];
      nSalary = json['salary'];
      nManager = json['manager'];
      nDateOfBirth = json['date_of_birth'];
      nEmpNum = json['emp_number'];
      imageUrl = json['imageUrl'];
      about = json['about'];
      updatedEmail = json['updatedEmail'];
    }catch(e){
      var json = result.body;
      return json;
    }

    return Future.delayed(loginTime).then((value) => null);
  }

  Future<String?> _signupUser(SignupData data) async {
    String username = data.additionalSignupData!['username']!;
    String department = data.additionalSignupData!['department']!;
    String salary = data.additionalSignupData!['salary']!;
    String manager = data.additionalSignupData!['manager']!;
    String dateOfBirth = data.additionalSignupData!['dateOfBirth']!;
    String empNum = data.additionalSignupData!['empNum']!;
    var result = await http.post(Uri.parse("${uri}signUp/"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(
          <String, String>{
            "email": data.name as String,
            "password": data.password as String,
            "full_name": username,
            "department": department,
            "salary": salary,
            "manager": manager,
            "dateOfBirth": dateOfBirth,
            "empNum": empNum,
          },
        ));
    var json = result.body;
    if(json == 'success'){
      nUsername = username;
      nEmail = data.name;
      nDepartment = department;
      nSalary = 'R$salary';
      nManager = manager;
      nDateOfBirth = dateOfBirth;
      nEmpNum = empNum;
    }
    else{
      return 'Signing in not successful';
    }

    return null;
  }

  Future<String?> _recoverPassword(String name) async {
    debugPrint('Name: $name');

    return Future.delayed(loginTime).then((_) {
      return "Not Working Yet";
    });
  }

  String? _nameValidator(String? name) {
    String? error;
    if (name == null || name == "") {
      error = "Username is required!";
    }
    return error;
  }

  String? _departmentValidator(String? name) {
    String? error;
    if (name == null || name == "") {
      error = "Role is required!";
    }
    return error;
  }

  String? _empNumValidator(String? name) {
    String? error;
    if (name == null || name == "") {
      error = "Employee Number is required!";
    }
    return error;
  }

  String? _dateOfBirthValidator(String? name) {
    String? error;
    if (name == null || name == "") {
      error = "Date Of Birth is required!";
      return error;
    }
    try{
      int month = int.parse(name.substring(0,2));
      int day = int.parse(name.substring(3, 5));
      int.parse(name.substring(6, 10));
      if(month > 12 || day > 31){
        return "Date Should Be In The \"MM/DD/YYYY\" format!";
      }
      return null;
    }catch(e){
      return '$e';
    }
  }

  String? _reportingManagerValidator(String? name) {
    String? error;
    if (name == null || name == "") {
      error = "Reporting Manager is required!";
    }
    return error;
  }

  String? _salaryValidator(String? name) {
    String? error;
    if (name == null || name == "") {
      error = "Salary is required!";
    }
    return error;
  }

  @override
  Widget build(BuildContext context) {
    navigateToHome() {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SidebarXExampleApp()),
          (Route<dynamic> route) => false);
    }

    return FlutterLogin(
      key: const Key('loginPage'),
      title: 'Epi-Use',
      theme: LoginTheme(
        primaryColor: const Color(0xFF464667),
        accentColor: Colors.white,
        titleStyle: const TextStyle(color: Colors.white),
      ),
      scrollable: true,
      onLogin: _authUser,
      onSignup: _signupUser,
      loginAfterSignUp: true,
      onSubmitAnimationCompleted: () async {
        await globals.getUsers();
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('username', nUsername!);
        sharedPreferences.setString('email', nEmail!);
        sharedPreferences.setString('department', nDepartment!);
        sharedPreferences.setString('salary', nSalary!);
        sharedPreferences.setString('manager', nManager!);
        sharedPreferences.setString('dateOfBirth', nDateOfBirth!);
        sharedPreferences.setString('empNum', nEmpNum!);
        if(about != null){
          sharedPreferences.setString('about', about!);
          globals.about = sharedPreferences.getString('about');
        }
        if(imageUrl!=null){
          sharedPreferences.setString('imageUrl', imageUrl!);
          globals.imageUrl = imageUrl;
        }
        if(updatedEmail != null){
          sharedPreferences.setString('updatedEmail', updatedEmail!);
          globals.updatedEmail = sharedPreferences.getString('updatedEmail');
        }
        globals.email = sharedPreferences.getString('email');
        globals.username = sharedPreferences.getString('username');
        globals.department = sharedPreferences.getString('department');
        globals.salary = sharedPreferences.getString('salary');
        globals.manager = sharedPreferences.getString('manager');
        globals.dateOfBirth = sharedPreferences.getString('dateOfBirth');
        globals.empNum = sharedPreferences.getString('empNum');

        navigateToHome();
      },
      onRecoverPassword: _recoverPassword,
      additionalSignupFields: [
        UserFormField(
          keyName: 'username',
          userType: LoginUserType.name,
          displayName: "Username",
          fieldValidator: _nameValidator,
        ),
        UserFormField(
          keyName: 'empNum',
          userType: LoginUserType.name,
          displayName: "Employee number",
          fieldValidator: _empNumValidator,
          icon: const Icon(Icons.numbers),
        ),
        UserFormField(
          keyName: 'department',
          userType: LoginUserType.name,
          displayName: "Role",
          fieldValidator: _departmentValidator,
          icon: const Icon(Icons.work),
        ),
        UserFormField(
          keyName: 'dateOfBirth',
          userType: LoginUserType.name,
          displayName: "Date Of Birth(MM/DD/YYYY)",
          fieldValidator: _dateOfBirthValidator,
          icon: const Icon(Icons.date_range),
        ),
        UserFormField(
          keyName: 'manager',
          userType: LoginUserType.name,
          displayName: "Reporting Manager Email",
          fieldValidator: _reportingManagerValidator,
          icon: const Icon(Icons.person),
        ),
        UserFormField(
          keyName: 'salary',
          userType: LoginUserType.name,
          displayName: "Salary",
          fieldValidator: _salaryValidator,
          icon: const Icon(Icons.money),
        ),

      ],
      messages: LoginMessages(
        recoverPasswordDescription: "We will send a link to the email account.",
        recoverPasswordSuccess: 'If your account exists email has been sent!',
        additionalSignUpFormDescription: "Fill in this form to complete signup",
        signUpSuccess: "Successfully signed up",
      ),
    );
  }
}
