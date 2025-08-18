import 'package:fitness/service/ApiService.dart';
import 'package:fitness/models/User.dart';

class UserRepository {
  final ApiService service;

  UserRepository(this.service);

  Future<bool> isValidName(String name) async {
    //this metot will check whether there is a user with the existing name
    try {
      final obj = await service.getUserByName(name);
      /*       User user = User(
        userId: obj['user_id'],
        userName: obj['userName'],
        birthday:  obj['birthday'], //for some reason there is a problem with converting date to string??
        password: obj['user_password'],
      ); */

      return false;
    } catch (e) {
      print(e);
      print("User with name " + name + " does not exits.");
      return true;
    }
  }

  Future<Map<String, dynamic>> validateLogin(
    String userName,
    String password,
  ) async {
    final a = service.validateLogin(userName, password);
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
