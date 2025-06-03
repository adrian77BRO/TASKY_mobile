import 'package:tasky/user/data/models/login.dart';
import 'package:tasky/user/data/models/user.dart';

abstract class IUserService {
  Future<Map<String, dynamic>> login(Login user);
  Future<Map<String, dynamic>> register(User user);
}
