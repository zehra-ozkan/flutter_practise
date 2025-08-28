import 'dart:io';

import 'package:fitness/pages/home.dart';
import 'package:fitness/service/ApiService.dart';
import 'package:fitness/models/UserRepository.dart';
import 'package:fitness/service/token_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

String? sessionId; // Store this globally after login

class NewPost extends StatefulWidget {
  //final DepartmentRepository depRepo; // Store as a field

  const NewPost({super.key});
  //bool hidden = true;
  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final userNameField = TextEditingController();
  Widget containerChild = Icon(Icons.person_3_sharp);
  UserRepository? userRepo;
  File? _image; //this will be used to change the profile picture

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userRepo = Provider.of<UserRepository>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          _profilePic(), //
          b(),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        "New Post",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500, //I am
        ),
      ),
      backgroundColor: Colors.black,
      leading: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/homepage");
        },
        child: Container(
          margin: EdgeInsets.all(15),
          alignment: Alignment.center,
          /*           decoration: BoxDecoration(
            color: Color.fromARGB(255, 207, 221, 246), //I like this color
            borderRadius: BorderRadius.circular(10),
          ), */
          child: Icon(
            Icons.close,
            size: 28,
            color: Colors.white,
          ), // I can also use flutter's icons
        ),
      ),

      actions: [
        GestureDetector(
          onTap: () async {
            print("\nrah rah rah \n");
            await _uploadNewPost();
            print("\nrah rah rah \n");

            Navigator.pushNamed(context, "/homepage");
          },
          child: Container(
            //this is the bar on top
            width: 50,
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,

            /* a */
            child: Text(
              "Next",
              style: TextStyle(
                color: const Color.fromARGB(255, 38, 110, 244),
                fontSize: 18,
                fontWeight: FontWeight.w500, //I am
              ),
            ),
          ),
        ),
      ],
    );
  }

  Flexible _profilePic() {
    //TODO fix the circle
    return Flexible(
      fit: FlexFit.loose, // Doesn't force expansion
      child: FractionallySizedBox(
        heightFactor: 0.75,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 207, 221, 246), //I like this color
            borderRadius: BorderRadius.circular(10),
          ),
          width: 350,
          margin: EdgeInsets.all(10),
          // alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              containerChild,
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _openPickerCam();
                    },
                    child: Text("Add from camera"),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      _openPicker();
                    },
                    child: Text("Add from gallery"),
                  ),
                ],
              ),
            ],
          ), //profile picture size
        ),
      ),
    );
  }

  Padding b() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        //this field takes as string name TODO check empty
        controller: textController,
        obscureText: false,
        decoration: InputDecoration(
          labelText: "Text",
          contentPadding: EdgeInsets.all(15),
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.note_alt_rounded),
        ),
      ),
    );
  }

  Future<void> _openPicker() async {
    print("inside picking object");
    final _picker = ImagePicker();

    final _pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (_pickedImage != null) {
      String? token = await TokenService.getToken();
      if (token == null) return;
      await cropImage(_pickedImage!.path);

      setState(() {
        containerChild = SizedBox(child: Image.file(_image!));
      });
    }
  }

  Future<void> _openPickerCam() async {
    print("inside picking object");
    final _picker = ImagePicker();

    final _pickedImage = await _picker.pickImage(source: ImageSource.camera);

    if (_pickedImage != null) {
      await cropImage(_pickedImage!.path);

      setState(() {
        containerChild = Image.file(_image!);
      });
    }
  }

  Future<void> cropImage(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: CropAspectRatio(ratioX: 50, ratioY: 50),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: const Color.fromARGB(142, 17, 87, 218),
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
      ],
    );
    setState(() {
      _image = File(croppedFile!.path);
    });
  }

  _uploadNewPost() async {
    String? token = await TokenService.getToken();
    if (token == null) return; //TODO no image selected check

    userRepo?.uploadPost(token, _image!.path, textController.text);
  }

  @override
  void dispose() {
    super.dispose();

    // Clean up the controller when the widget is disposed.
    userNameField.dispose();
  }
}
