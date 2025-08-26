import 'package:fitness/pages/home.dart';
import 'package:fitness/service/ApiService.dart';
import 'package:fitness/models/UserRepository.dart';
import 'package:fitness/service/token_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String? sessionId; // Store this globally after login

class NameUpdate extends StatefulWidget {
  //final DepartmentRepository depRepo; // Store as a field

  const NameUpdate({super.key});
  //bool hidden = true;
  @override
  State<NameUpdate> createState() => _NameUpdateState();
}

class _NameUpdateState extends State<NameUpdate> {
  final userNameField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("this is the app var"),
        leading: Icon(Icons.girl),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    // Clean up the controller when the widget is disposed.
    userNameField.dispose();
  }
}
