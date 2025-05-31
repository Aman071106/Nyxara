import 'package:nyxara/domain/repositories/user_repository.dart';

class SendOtp {
  final UserRepository userRepository;
  SendOtp({required this.userRepository});
  Future<int?> execute(String email) async {
    return userRepository.SendOTP(email);
  }
}
