import 'package:nyxara/domain/repositories/breach_repository.dart';

class CheckBreachUsecase {
  final BreachRepository breachRepository;
  CheckBreachUsecase({required this.breachRepository});
  Future<bool> execute(String email) async {
    return breachRepository.checkBreach(email);
  }
}
