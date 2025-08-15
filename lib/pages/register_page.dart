import 'package:fitness/models/category_models.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  List<CategoryModel> models = [];
  final TextEditingController pass1Controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("data")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start, //to the left
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                child: a(
                  "Please Enter your birthday",
                  Icon(Icons.date_range_outlined),
                  nameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                child: a(
                  "Please Enter User Name",
                  Icon(Icons.person_3),
                  dayController,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                child: a(
                  "Please Enter your password",
                  Icon(Icons.lock_outline_rounded),
                  pass1Controller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                child: a(
                  "Please Repeat your password",
                  Icon(Icons.lock_outline_rounded),
                  pass2Controller,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              var name = nameController.text;
              var day = dayController.text;
              var pas1 = pass1Controller.text;
              var pas2 = pass2Controller.text;
            },
            child: Text("sdaf"),
          ),
        ],
      ),
    );
  }

  static TextField a(String txt, Icon icon, TextEditingController ctr) {
    return TextField(
      //this field takes as string name TODO check empty
      controller: ctr,
      obscureText: false,
      decoration: InputDecoration(
        labelText: txt,
        contentPadding: EdgeInsets.all(15),
        border: OutlineInputBorder(),
        prefixIcon: icon,
      ),
    );
  }
}
