import 'package:fitness/pages/posts_page.dart';
import 'package:fitness/pages/profile_page.dart';
import 'package:fitness/service/ApiService.dart';
import 'package:fitness/models/DepartmentRepository.dart';
import 'package:fitness/models/UserRepository.dart';
import 'package:fitness/pages/home.dart';
import 'package:fitness/pages/intro_page.dart';
import 'package:fitness/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final apiService = ApiService();
  final DepartmentRepository dr = DepartmentRepository(apiService);
  final UserRepository ur = UserRepository(apiService);

  /*  runApp(MyApp(departmentRepo: dr, userRepository: ur)); */
  runApp(
    Provider(create: (context) => UserRepository(apiService), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Map<String, dynamic> data = {'d': 1};
    final userRepo = Provider.of<UserRepository>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'), //login check later time
      home: IntroPage(userRepo: userRepo),

      routes: {
        '/homepage': (context) => HomePage(), //I will make it an invalid userId
        '/profilepage': (context) =>
            ProfilePage(), //I will make it an invalid userId
        '/postspage': (context) => Posts(), //I will make it an invalid userId
        '/intropage': (context) => IntroPage(userRepo: userRepo),
        '/registerpage': (context) => RegisterPage(userRepo: userRepo),
      },
    );
  }
}
