import 'package:fitness/models/ApiService.dart';
import 'package:fitness/models/Department.dart';
import 'package:fitness/models/DepartmentRepository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // The 'as http' part is crucial

class IntroPage extends StatefulWidget {
  final DepartmentRepository depRepo; // Store as a field

  const IntroPage({required this.depRepo, super.key});
  //bool hidden = true;
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool hidden = true;
  final myController = TextEditingController();
  final myController1 = TextEditingController(); //this is messy

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

        infoTextFields(eyeIcon, myController, myController1),

        ElevatedButton(
          onPressed: () async {
            /*             bool valid = await Department.isValid(
              int.tryParse(myController1.text) ?? 0,
              myController.text,
            ); */
            var textId = int.tryParse(myController1.text);
            var textName = myController.text;
            bool valid = await widget.depRepo.isValid(textId!, textName);
            if (valid) {
              Navigator.pushNamed(context, "/homepage");
            } else {
              print("I have failed\n");
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          child: Text("this is the button"),
        ),
      ],
    );
  }

  Column infoTextFields(
    Icon eyeIcon,
    TextEditingController myController,
    TextEditingController myController1,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            //this field takes as string name TODO check empty
            obscureText: false,
            controller: myController,
            decoration: InputDecoration(
              labelText: "this is the label text 1",
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
            controller: myController1,
            decoration: InputDecoration(
              labelText: "this is the label text 2",
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
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myController1.dispose();
    super.dispose();
  }
}
