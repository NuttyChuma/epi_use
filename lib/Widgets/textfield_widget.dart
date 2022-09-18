import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String text;
  final int maxLines;
  final ValueChanged<String> onChanged;
  const TextFieldWidget({Key? key, required this.label, required this.text, required this.onChanged, this.maxLines = 1}) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.text);
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60,),
          Text(
            widget.label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey.shade300)
          ),
          const SizedBox(height: 10,),
          TextField(
            style: TextStyle(color: Colors.grey.shade300),
            controller: _controller,
            maxLines: widget.maxLines,
            minLines: 1,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              ),
            ),
            onChanged: widget.onChanged,
          )
        ],
      ),
    );
  }
}
