import 'package:fitness/models/ApiService.dart';
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

  Future<bool> validateLogin(String userName, String password) async {
    bool a = await service.validateLogin(userName, password);

    return a;
  }
}
