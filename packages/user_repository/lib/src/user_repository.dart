import 'package:user_repository/src/models/models.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  User? user;
  Future<User?> getUser() async {
    if (user != null) return user;
    return Future.delayed(Duration(seconds: 1), () => User(Uuid().v4()));
  }
}
