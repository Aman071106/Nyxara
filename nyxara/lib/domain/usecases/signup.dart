import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class SignUpUser {
  final UserRepository repository;

  SignUpUser(this.repository);

  Future<UserEntity?> execute( String email, String password) {
    return repository.signUpUser(email, password);
  }
}