import 'package:nyxara/domain/repositories/breach_repository.dart';

class CheckBreach {
  final BreachRepository breachRepository;
  CheckBreach({required this.breachRepository});
  Future<bool> execute(String email) async {
    return breachRepository.checkBreach(email);
  }
}
