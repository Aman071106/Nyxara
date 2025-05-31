import 'package:nyxara/domain/repositories/user_repository.dart';

class LogoutUsecase {
  final UserRepository userRepository;
  LogoutUsecase(this.userRepository);
  Future<void> execute() async {
    userRepository.logout();
  }
}
