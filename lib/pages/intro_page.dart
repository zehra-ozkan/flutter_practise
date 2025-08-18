import 'package:fitness/service/ApiService.dart';
import 'package:fitness/models/Department.dart';
import 'package:fitness/models/DepartmentRepository.dart';
import 'package:fitness/models/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // The 'as http' part is crucial

class IntroPage extends StatefulWidget {
  //final DepartmentRepository depRepo; // Store as a field
  final UserRepository userRepo;

  const IntroPage({required this.userRepo, super.key});
  //bool hidden = true;
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool hidden = true;
  final userNameField = TextEditingController();
  final passwordField = TextEditingController(); //this is messy
  String? failMessage = null; //I will set it initially to null

  @override
  Widget build(BuildContext context) {
    var visible = Icon(
      Icons.visibility,
    ); //these can be carried inside the metots
    var hiddenOff = Icon(Icons.visibility_off);
    var eyeIcon = hidden ? hiddenOff : visible;

    return Scaffold(
      appBar: AppBar(title: Text("this is the app var")),
      body: loginField(eyeIcon, context),
    );
  }

  Column loginField(Icon eyeIcon, BuildContext context) {
    // Initialize with a default Department instance
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("This is the first text"),

        infoTextFields(eyeIcon, userNameField, passwordField),

        ElevatedButton(
          onPressed: () async {
            /*             bool valid = await Department.isValid(
              int.tryParse(myController1.text) ?? 0,
              myController.text,
            ); */
            var password = passwordField.text;
            var userName = userNameField.text;
            var data = await widget.userRepo.validateLogin(userName, password);

            bool valid = data['success'];
            int id = data['userId'];
            //  bool valid = await widget.depRepo.isValid(textId!, textName);
            if (valid) {
              Navigator.pushNamed(context, "/homepage");
            } else {
              print("failed login");
              setState(() {
                failMessage = "UserName or Password wrong";
              });
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          child: Text("Log In"),
        ),
      ],
    );
  }

  Column infoTextFields(
    Icon eyeIcon,
    TextEditingController userNameField,
    TextEditingController passwordField,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            //this field takes as string name TODO check empty
            obscureText: false,
            controller: userNameField,
            decoration: InputDecoration(
              labelText: "Enter User Name",
              contentPadding: EdgeInsets.all(15),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_3),
            ),
          ),
        ),
        SizedBox(height: 15),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            obscureText: hidden,
            controller: passwordField,
            decoration: InputDecoration(
              labelText: "Enter Password",
              contentPadding: EdgeInsets.all(15),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),

              suffixIcon: IconButton(
                icon: eyeIcon,
                onPressed: () {
                  setState(() {
                    hidden = !hidden;
                  });
                },
              ),
            ),
          ),
        ),
        if (failMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 5),
            child: Text(
              failMessage!,
              style: TextStyle(color: const Color.fromARGB(255, 177, 35, 25)),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 5),
          child: TextButton(
            onPressed: () async {
              print("lah lah lah");

              Navigator.pushNamed(context, "/registerpage");
            },
            child: Text("First time here? Register to the app from here."),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();

    // Clean up the controller when the widget is disposed.
    userNameField.dispose();
    passwordField.dispose();
  }
}
