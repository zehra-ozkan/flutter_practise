import 'package:fitness/models/department.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // The 'as http' part is crucial

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    var id;
    var name;

    var hiddenIcon = Icon(
      Icons.visibility,
    ); //these can be carried inside the metots
    var hiddenOff = Icon(Icons.visibility_off);
    var icon = hidden ? hiddenOff : hiddenIcon;

    return Scaffold(
      appBar: AppBar(title: Text("this is the app var")),
      body: loginField(icon, context),
    );
  }

  Column loginField(Icon icon, BuildContext context) {
    final myController = TextEditingController();
    final myController1 = TextEditingController(); //this is messy
    // Initialize with a default Department instance
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("This is the first text"),

        infoTextFields(icon, myController, myController1),

        ElevatedButton(
          onPressed: () async {
            bool k = await Department.isValid(
              int.tryParse(myController1.text) ?? 0,
              myController.text,
            );
            if (k) {
              Navigator.pushNamed(context, "/homepage");
            } else {
              print("I have failed\n");
            }
          },
          child: Text("this is the button"),
        ),
      ],
    );
  }

  Column infoTextFields(
    Icon icon,
    TextEditingController myController,
    TextEditingController myController1,
  ) {
    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      myController.dispose();
      myController1.dispose();
      super.dispose();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
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
                icon: icon,
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

  void buttonPressed() {}
}
