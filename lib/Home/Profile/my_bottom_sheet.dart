import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({Key? key}) : super(key: key);

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {

  Future pickImage()async{
    debugPrint('picker');
    final pickedFile = await ImagePickerPlugin().pickImage(source: ImageSource.gallery);
    // await ImagePicker().pickImage(source: ImageSource.gallery);
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => pickImage(),
                icon: const Icon(
                  Icons.photo_size_select_actual_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              const Text("Select Image From Gallery"),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              const Text("Take Image"),
            ],
          ),
        ],
      ),
    );
  }
}
