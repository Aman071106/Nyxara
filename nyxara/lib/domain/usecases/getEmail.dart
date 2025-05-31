import 'package:nyxara/domain/repositories/user_repository.dart';

class Getemail {
  final UserRepository userRepository;
  Getemail(this.userRepository);
  Future<String> execute() {
    return userRepository.getSavedEmail();
  }
}
