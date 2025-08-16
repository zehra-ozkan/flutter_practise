import 'package:fitness/service/ApiService.dart';
import 'package:fitness/models/User.dart';

class UserRepository {
  final ApiService service;

  UserRepository(this.service);

  Future<bool> isValid(String name, String password) async {
    try {
      final obj = await service.getUserByName(name);
      User user = User(
        userId: obj['user_id'],
        userName: obj['user_name'],
        birthday: obj['birthday'],
        password: obj['user_password'],
      );
      return user.password == password;
    } catch (e) {
      print("SOMETHİNG IS WROONG!!!!!!!!!!!!!!!!!");
      return false;
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
}
