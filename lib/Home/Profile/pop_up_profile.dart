import 'package:flutter/material.dart';

class PopUpProfile extends StatefulWidget {
  const PopUpProfile({Key? key}) : super(key: key);

  @override
  State<PopUpProfile> createState() => _PopUpProfileState();
}

class _PopUpProfileState extends State<PopUpProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('hello'),
      ),
    );
  }
}
