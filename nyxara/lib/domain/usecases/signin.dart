import '../repositories/user_repository.dart';

class SignInUser {
  final UserRepository repository;

  SignInUser(this.repository);

  Future<String?> execute(String email, String password) {
    return repository.signInUser(email, password);
  }
}