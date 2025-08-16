import 'package:fitness/models/UserRepository.dart';
import 'package:fitness/models/category_models.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.userRepo});
  final UserRepository userRepo;

  //  List<CategoryModel> models = [];
  final TextEditingController pass1Controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();
  DateTime? selectedDate;

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
                  "Please enter your birthday (dd/mm/yyyy))", //TODO ASSUME THEY ENTER CORRECT
                  Icon(Icons.person_3),
                  dayController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                child: a(
                  "Please Enter User Name",
                  Icon(Icons.date_range_outlined),
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
            onPressed: () async {
              String name = nameController.text;
              String day = dayController.text;
              String pas1 = pass1Controller.text;
              String pas2 = pass2Controller.text;

              /* if (pas2 != pas1) { //TODO VALIDATION

    } */
              DateTime date = DateTime(2025, 5, 30);
              //DateTime justDate = DateTime(flutterDateTime.year, flutterDateTime.month, flutterDateTime.day);
              var data = await userRepo.validateRegistration(
                "nyanko",
                "pas1",
                date,
              );
              bool valid = data['success'];
              if (valid) {
                print("successful");
                Navigator.pushNamed(context, "/intropage");
              } else {
                print("I have failed in registration\n");
              }
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

  void _onSelectionChanged(
    DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs,
  ) {}

  void _buttonPressed() async {}
}
