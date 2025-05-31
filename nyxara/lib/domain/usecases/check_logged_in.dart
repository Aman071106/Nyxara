import 'package:nyxara/domain/repositories/user_repository.dart';

class CheckLoggedIn {
  final UserRepository userRepository;
  CheckLoggedIn(this.userRepository);
  Future<bool> execute() async {
    return userRepository.isLoggedIn();
  }
}
