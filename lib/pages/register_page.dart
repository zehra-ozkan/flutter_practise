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
                  "Please Enter User Name",
                  Icon(Icons.date_range_outlined),
                  nameController,
                  validateName,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                child: a(
                  "Please enter your birthday (dd/mm/yyyy))", //TODO ASSUME THEY ENTER CORRECT
                  Icon(Icons.person_3),
                  dayController,
                  validateName,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                child: a(
                  "Please Enter your password",
                  Icon(Icons.lock_outline_rounded),
                  pass1Controller,
                  validatePassword,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                child: a(
                  "Please Repeat your password",
                  Icon(Icons.lock_outline_rounded),
                  pass2Controller,
                  validatePassword,
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

  bool _validate = false;
  TextFormField a(
    String txt,
    Icon icon,
    TextEditingController ctr,
    Function f,
  ) {
    return TextFormField(
      //this field takes as string name TODO check empty
      controller: ctr,
      obscureText: false,
      decoration: InputDecoration(
        labelText: txt,
        contentPadding: EdgeInsets.all(15),
        border: OutlineInputBorder(),
        errorText: f(ctr.text) == "" ? null : f(ctr.text),
        prefixIcon: icon,
      ),
    );
  }

  String validatePassword(String value) {
    print("values = " + value);
    if (!(value.length < 8) && value.isNotEmpty) {
      print("here!!");
      return "Password should contain at least 8 characters!";
    }
    return "";
  }

  String validateName(String value) {
    if (value.isEmpty == false) {
      return "This name already exists.";
    }
    return "";
  }

  void _onSelectionChanged(
    DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs,
  ) {}

  void _buttonPressed() async {}
}
