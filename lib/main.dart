import 'package:fitness/service/ApiService.dart';
import 'package:fitness/models/DepartmentRepository.dart';
import 'package:fitness/models/UserRepository.dart';
import 'package:fitness/pages/home.dart';
import 'package:fitness/pages/intro_page.dart';
import 'package:fitness/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final apiService = ApiService();
  final DepartmentRepository dr = DepartmentRepository(apiService);
  final UserRepository ur = UserRepository(apiService);

  runApp(MyApp(departmentRepo: dr, userRepository: ur));
}

class MyApp extends StatelessWidget {
  final DepartmentRepository departmentRepo;
  final UserRepository userRepository;
  const MyApp({
    required this.departmentRepo,
    required this.userRepository,
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'), //login check later time
      home: IntroPage(depRepo: departmentRepo, userRepo: userRepository),

      routes: {
        '/homepage': (context) => HomePage(),
        '/intropage': (context) =>
            IntroPage(depRepo: departmentRepo, userRepo: userRepository),
        '/registerpage': (context) => RegisterPage(),
      },
    );
  }
}
