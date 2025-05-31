import 'package:nyxara/domain/entities/user_entity.dart';
import 'package:nyxara/domain/repositories/user_repository.dart';
import '../datasources/user_datasource.dart';
import '../datasources/auth_shared_preference_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final NyxaraDB authDatabase;
  final AuthLocalDataSource shared_auth;
  UserRepositoryImpl(this.authDatabase, this.shared_auth);

  @override
  Future<String?> signInUser(String email, String password) async {
    final user = await authDatabase.checkUser(email, password);
    if (user != null) {
      await shared_auth.saveToken(user, email);

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

  @override
  Future<bool> isLoggedIn() async {
    String? token = await shared_auth.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    await shared_auth.clearToken();
  }

  @override
  Future<String> getSavedEmail() async {
    return (await shared_auth.getEmail())!;
  }
  @override
  Future<int?> SendOTP(String email) async{
    return await authDatabase.SendOtp(email);
  }
}
