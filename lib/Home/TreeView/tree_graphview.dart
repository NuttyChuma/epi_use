import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:graphview/GraphView.dart';
import '../../my_globals.dart' as globals;
import '../Profile/edit_profile_page.dart';

class TreeViewPage extends StatefulWidget {
  const TreeViewPage({super.key});

  @override
  State<TreeViewPage> createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (globals.users != null)
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: InteractiveViewer(
                        constrained: false,
                        boundaryMargin: const EdgeInsets.all(100),
                        minScale: 0.01,
                        maxScale: 5.6,
                        child: GraphView(
                          graph: graph,
                          algorithm: BuchheimWalkerAlgorithm(
                              builder, TreeEdgeRenderer(builder)),
                          paint: Paint()
                            ..color = Colors.black
                            ..strokeWidth = 1
                            ..style = PaintingStyle.stroke,
                          builder: (Node node) {
                            // I can decide what widget should be shown here based on the id
                            var a = node.key!.value as int?;
                            return rectangleWidget(a);
                          },
                        )),
                  ),
                ),
              ],
            )
          : null,
      // drawer: Text('hello'),
    );
  }

  Random r = Random();
  final gravatar = Gravatar("ygg@beerstorm.net");
  String uri = 'http://192.168.7.225:5000/';

  Widget rectangleWidget(int? a) {
    return InkWell(
      onTap: () {
        debugPrint('${globals.globalInt}');
        openDialog(a);
      },
      child: Stack(
        children: [
          SizedBox(
              height: 120.0,
              width: 400.0,
              child: Card(
                elevation: 10.0,
                color: Colors.grey.shade200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(globals.users![a!]['full_name']),
                    (globals.users![a]['updatedEmail'] == null)? Text('Email: ${globals.users![a]['email']}'):Text('Email: ${globals.users![a]['updatedEmail']}'),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(globals.users![a]['department'])
                  ],
                ),
              )),
          CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.transparent,
            backgroundImage: (globals.users![a]['imageUrl'] == null)?
            NetworkImage(Gravatar(globals.users![a]['email']).imageUrl()):
            NetworkImage(globals.users![a]['imageUrl']),
          ),
        ],
      ),
    );
  }

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    getUsers();
    if (globals.users != null) {
      createGraph();
    }
    super.initState();
  }

  getUsers() async{
    if(globals.users == null) {
      await globals.getUsers();
      createGraph();
      setState((){});
    }
  }

  createGraph() {
    List nodes = [];

    for (int i = 0; i < globals.users!.length; i++) {
      nodes.add(Node.Id(i));
    }
    for (int i = 0; i < nodes.length; i++) {
      if (globals.users![i]['email'] != globals.users![i]['manager'] &&
          globals.users![i]['manager'] != null) {
        for (int j = 0; j < nodes.length; j++) {
          if (globals.users![i]['manager'] == globals.users![j]['email']) {
            graph.addEdge(nodes[j], nodes[i]);
          }
        }
      }
    }

    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }

  Future openDialog(int index) {
    return showDialog(
        context: context,
        builder: (context) {
          debugPrint('${globals.users![index]['image']}');
          return AlertDialog(
            backgroundColor: Colors.grey.shade100,
            title: ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.transparent,
                backgroundImage: (globals.users![index]['imageUrl'] == null)?
                    NetworkImage(Gravatar(globals.users![index]['email']).imageUrl()):
                    NetworkImage(globals.users![index]['imageUrl']),
              ),
              title: Text(globals.users![index]['full_name']),
              subtitle:(globals.users![index]['updatedEmail'] == null)? Text('Email: ${globals.users![index]['email']}'):Text('Email: ${globals.users![index]['updatedEmail']}'),
            ),
            content: SizedBox(
              // height: 200.0,
              width: 300.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Works in ${globals.users![index]['department']}'),
                  const SizedBox(height: 10.0,),
                  Text('Reporting manager: ${globals.users![index]['manager']}'),
                  const SizedBox(height: 10.0,),
                  Text('Employee Number: ${globals.users![index]['emp_number']}'),
                  const SizedBox(height: 10.0,),
                  Text('Date Of Birth: ${globals.users![index]['date_of_birth']}'),
                  const SizedBox(height: 10.0,),
                  Text('Salary: ${globals.users![index]['salary']}'),
                  const SizedBox(height: 10.0,),
                  const Text('About:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                  const SizedBox(height: 5.0,),
                  if (globals.users![index]['about'] != null)
                    Text('${globals.users![index]['about']}'),
                  const SizedBox(height: 5.0,),
                ],
              ),
            ),
            actions: [
              if(globals.users![index]['email'] == globals.email)
                ElevatedButton(onPressed: () async{
                  Navigator.pop(context);
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EditProfilePage()));
                  setState(() {});
                }, child: const Text('Edit')),
            ],
          );
        });
  }
}