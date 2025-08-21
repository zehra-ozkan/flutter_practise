import 'package:fitness/service/ApiService.dart';
import 'package:fitness/models/User.dart';

class UserRepository {
  final ApiService service;

  UserRepository(this.service);

  //is valid name will be done inside the addUser metod

  Future<String?> validateLogin(String userName, String password) async {
    final a = service.validateLogin(userName, password);
    print("we are in a ");
    //TODO maybe I can add checks here
    return a;
  }

  Future<Map<String, dynamic>> validateRegistration(
    String userName,
    String password,
    DateTime date,
  ) async {
    final a = service.validateRegistration(userName, password, date);
    //TODO maybe I can add checks here
    return a;
  }

  Future<User> getCurrentUser(String sessionId) async {
    return service.getCurrentUser(sessionId);
  }
}
