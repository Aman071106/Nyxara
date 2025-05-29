import 'package:nyxara/domain/entities/user_entity.dart';
import 'package:nyxara/domain/repositories/user_repository.dart';
import '../datasources/user_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final NyxaraDB authDatabase;
  UserRepositoryImpl(this.authDatabase);

  @override
  Future<String?> signInUser(String email, String password) async {
    final user = await authDatabase.checkUser(email, password);
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  @override
  Future<UserEntity?> signUpUser(String email, String password) async {
    final user = await authDatabase.createUser(email, password);
    if (user != null) {
      return UserEntity(email: user.email, password: user.password);
    } else {
      return null;
    }
  }

  
}
