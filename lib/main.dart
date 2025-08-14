import 'package:fitness/models/ApiService.dart';
import 'package:fitness/models/DepartmentRepository.dart';
import 'package:fitness/pages/home.dart';
import 'package:fitness/pages/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final apiService = ApiService();
  final DepartmentRepository dr = DepartmentRepository(apiService);

  runApp(MyApp(departmentRepo: dr));
}

class MyApp extends StatelessWidget {
  final DepartmentRepository departmentRepo;
  const MyApp({required this.departmentRepo, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: IntroPage(depRepo: departmentRepo),

      routes: {
        '/homepage': (context) => HomePage(),
        '/intropage': (context) => IntroPage(depRepo: departmentRepo),
      },
    );
  }
}
