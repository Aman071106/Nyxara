import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> signUpUser(String email, String password);
  Future<String?> signInUser(String email, String password);
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<String> getSavedEmail();
}
