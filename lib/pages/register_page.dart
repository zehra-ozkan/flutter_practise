import 'package:date_field/date_field.dart';
import 'package:fitness/models/UserRepository.dart';
import 'package:fitness/models/category_models.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, required this.userRepo});
  final UserRepository userRepo;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController pass1Controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();

  String? passwordError; // For password mismatch
  String? nameError; // For name availability

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("data")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start, //to the left
        children: [
          Form(
            key: _formKey,
            child: Column(
              //this one wraps the input fields
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
                if (nameError !=
                    null) //this will appear after the button is clicked
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),

                    child: Text(
                      nameError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                /* Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                  child: a(
                    "Please enter your birthday (dd/mm/yyyy))", //TODO ASSUME THEY ENTER CORRECT
                    Icon(Icons.person_3),
                    dayController,
                    validatePassword,
                  ),
                ), */
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 14, right: 14),

                  child: DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    decoration: InputDecoration(
                      prefix: Icon(Icons.date_range_sharp),
                      contentPadding: EdgeInsets.all(15),
                      labelText: "Please enter your birthday",
                      border: OutlineInputBorder(),
                    ),
                    hideDefaultSuffixIcon: true,

                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365) * 90,
                    ),
                    lastDate: DateTime.now().add(const Duration(days: 40)),
                    /*                     initialPickerDateTime: DateTime.now().add(
                      const Duration(days: 20),
                    ), */
                    //it can also pick time how very cool!!
                    onChanged: (DateTime? value) {
                      selectedDate = value;
                    },
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
                    (value) =>
                        validatePasswordMatch(value, pass1Controller.text),
                  ),
                ),
                if (passwordError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      passwordError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                //this part checks all the validators
                // 2. Clear previous errors
                setState(() {
                  passwordError = null;
                  nameError = null;
                });

                // 3. Check password match
                if (pass2Controller.text != pass1Controller.text) {
                  setState(() {
                    passwordError = "Passwords don't match";
                  });
                  return;
                }

                // 4. Check name availability

                String name = nameController.text;
                DateTime day = selectedDate!;
                print(day);
                String pas1 = pass1Controller.text;
                String pas2 = pass2Controller.text;

                DateTime date = DateTime(2025, 5, 30);

                var data = await widget.userRepo.validateRegistration(
                  //the state can access its widget like this
                  name,
                  pas1,
                  day,
                );

                bool valid = data['success'];
                if (valid) {
                  print("successful");
                  Navigator.pushNamed(context, "/intropage");
                } else {
                  print("I have failed in registration\n");
                  setState(() {
                    nameError = "This name already exists";
                  });
                  return;
                }
              }
            },
            child: Text("Save New User"),
          ),
        ],
      ),
    );
  }

  TextFormField a(
    String txt,
    Icon icon,
    TextEditingController ctr,
    String? Function(String?) validator,
  ) {
    return TextFormField(
      //this field takes as string name TODO check empty
      controller: ctr,
      obscureText: false,
      decoration: InputDecoration(
        labelText: txt,
        contentPadding: EdgeInsets.all(15),
        border: OutlineInputBorder(),
        errorText: validator(ctr.text),
        prefixIcon: icon,
      ),
      validator:
          validator, // Add this line to use Flutter's built-in validation
      autovalidateMode: AutovalidateMode
          .onUserInteraction, // Add this for real-time validation
    );
  }

  String? validatePassword(String? value) {
    // Changed to accept String?
    if (value == null || value.isEmpty) return null;
    if (value.length < 8) {
      return "Password should contain at least 8 characters!";
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length < 5) {
      return "User Name should contain at least 5 characters!";
    }
    return null;
  }

  String? validateDay(String? value) {
    if (value == null || value.isEmpty) return null;
    /*     if (value.length < 5) {
      return "User Name should contain at least 5 characters!";
    } */
    return null;
  }

  String? validatePasswordMatch(String? value, String otherPassword) {
    if (value == null || value.isEmpty) {
      return "Please repeat your password";
    } else if (value != otherPassword) {
      return "Passwords don't match";
    }
    return null;
  }
}
