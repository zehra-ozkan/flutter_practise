import 'package:fitness/models/ApiService.dart';
import 'package:fitness/models/Department.dart';

class DepartmentRepository {
  final ApiService service;

  DepartmentRepository(this.service);

  Future<bool> departmentExists(String name) async {
    final departments = await service.getDepartments();
    for (Department dp in departments) {
      if (dp.name == name) {
        return true;
      }
    }
    return false;
  }

  Future<bool> isValid(int id, String name) async {
    try {
      final obj = await service.getDepartmentById(id);
      Department dp = Department(id: obj['id'], name: obj['name']);
      return dp.name == name;
    } catch (e) {
      print("SOMETHİNG IS WROONG!!!!!!!!!!!!!!!!!");
      return false;
    }
  }
}
