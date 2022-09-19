import 'package:flutter/material.dart';
import 'package:epi_use/my_globals.dart' as globals;
import 'package:flutter_gravatar/flutter_gravatar.dart';

import 'Profile/edit_profile_page.dart';

enum SingingCharacter { email, name, department, empNum }

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SingingCharacter? _character = SingingCharacter.name;
  dynamic globalValue;

  @override
  void initState() {
    super.initState();
  }

  List users = List.from(globals.users!);
  String searchBy = 'name';

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: (isSmallScreen)
          ? AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            )
          : null,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                    flex: 8,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 500,
                          mainAxisExtent: 77,
                        ),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16.0),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.grey.shade200,
                            child: Center(
                              child: ListTile(
                                isThreeLine: true,
                                leading: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: (users[index]['imageUrl'] ==
                                          null)
                                      ? NetworkImage(
                                          Gravatar(users[index]['email'])
                                              .imageUrl())
                                      : NetworkImage(users[index]['imageUrl']),
                                ),
                                title: Text(users[index]['full_name']),
                                subtitle: (users[index]['updatedEmail'] == null)
                                    ? Text(
                                        'Email: ${users[index]['email']}\nWorks in: ${users[index]['department']}')
                                    : Text(
                                        'Email: ${users[index]['updatedEmail']}\nWorks in: ${users[index]['department']}'),
                                onTap: () {
                                  openDialog(index);
                                },
                              ),
                            ),
                          );
                        })),
                if (!isSmallScreen)
                  Flexible(
                    flex: 3,
                    child: ListView(
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50.0, vertical: 25.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  labelText: 'Search',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0))),
                              onChanged: searchUser,
                            )),
                        const SizedBox(
                          height: 50.0,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              'Search By...',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ListTile(
                          title: const Text('Name',
                              style: TextStyle(color: Colors.white)),
                          leading: Radio<SingingCharacter>(
                            value: SingingCharacter.name,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                searchBy = 'name';
                                _character = value;
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              searchBy = 'name';
                              _character = SingingCharacter.name;
                            });
                          },
                        ),
                        ListTile(
                          title: const Text(
                            'Email',
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: Radio<SingingCharacter>(
                            value: SingingCharacter.email,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                searchBy = 'email';
                                _character = value;
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              searchBy = 'email';
                              _character = SingingCharacter.email;
                            });
                          },
                        ),
                        ListTile(
                          title: const Text('Role',
                              style: TextStyle(color: Colors.white)),
                          leading: Radio<SingingCharacter>(
                            value: SingingCharacter.department,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                searchBy = 'department';
                                _character = value;
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              searchBy = 'department';
                              _character = SingingCharacter.department;
                            });
                          },
                        ),
                        ListTile(
                          title: const Text('Employee Number',
                              style: TextStyle(color: Colors.white)),
                          leading: Radio<SingingCharacter>(
                            value: SingingCharacter.empNum,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                searchBy = 'empNum';
                                _character = value;
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              searchBy = 'empNum';
                              _character = SingingCharacter.empNum;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      endDrawer: (isSmallScreen)
          ? Drawer(
            child: Container(
                color: Colors.grey.withOpacity(0.5),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 25.0),
                        child: TextField(
                          decoration: InputDecoration(
                              labelText: 'Search',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0))),
                          onChanged: searchUser,
                        )),
                    const SizedBox(
                      height: 50.0,
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          'Search By...',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      title: const Text('Name',
                          style: TextStyle(color: Colors.white)),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.name,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            searchBy = 'name';
                            _character = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          searchBy = 'name';
                          _character = SingingCharacter.name;
                        });
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Email',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.email,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            searchBy = 'email';
                            _character = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          searchBy = 'email';
                          _character = SingingCharacter.email;
                        });
                      },
                    ),
                    ListTile(
                      title: const Text('Role',
                          style: TextStyle(color: Colors.white)),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.department,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            searchBy = 'department';
                            _character = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          searchBy = 'department';
                          _character = SingingCharacter.department;
                        });
                      },
                    ),
                    ListTile(
                      title: const Text('Employee Number',
                          style: TextStyle(color: Colors.white)),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.empNum,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            searchBy = 'empNum';
                            _character = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          searchBy = 'empNum';
                          _character = SingingCharacter.empNum;
                        });
                      },
                    ),
                  ],
                ),
              ),
          )
          : null,
    );
  }

  void searchUser(String query) {
    users = List.from(globals.users!);
    late String filterBy;
    if (searchBy == 'email') {
      filterBy = 'email';
    } else if (searchBy == 'name') {
      filterBy = 'full_name';
    } else if (searchBy == 'department') {
      filterBy = 'department';
    } else if (searchBy == 'empNum') {
      filterBy = 'emp_number';
    }
    final suggestions = users.where((user) {
      final username = user[filterBy].toLowerCase();
      final input = query.toLowerCase();

      return username.contains(input);
    }).toList();

    setState(() => users = suggestions);
  }

  Future openDialog(int index) {
    debugPrint(users[index]['email']);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade100,
            title: ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.transparent,
                backgroundImage: (users[index]['imageUrl'] == null)
                    ? NetworkImage(Gravatar(users[index]['email']).imageUrl())
                    : NetworkImage(users[index]['imageUrl']),
              ),
              title: Text(users[index]['full_name']),
              subtitle: (users[index]['updatedEmail'] == null)
                  ? Text('Email: ${users[index]['email']}')
                  : Text('Email: ${users[index]['updatedEmail']}'),
            ),
            content: SizedBox(
              // height: 200.0,
              width: 300.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Works in ${users[index]['department']}'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text('Reporting manager: ${users[index]['manager']}'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text('Employee Number: ${users[index]['emp_number']}'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text('Date Of Birth: ${users[index]['date_of_birth']}'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text('Salary: ${users[index]['salary']}'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'About:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  if (users[index]['about'] != null)
                    Text('${users[index]['about']}'),
                ],
              ),
            ),
            actions: [
              if (users[index]['email'] == globals.email)
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const EditProfilePage()));
                      users = globals.users!;
                      setState(() {});
                    },
                    child: const Text('Edit'))
            ],
          );
        });
  }
}
