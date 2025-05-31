import 'package:nyxara/domain/entities/advice_response_entity.dart';
import 'package:nyxara/domain/repositories/breach_repository.dart';

class FetchAdvice {
  final BreachRepository breachRepository;

  FetchAdvice({required this.breachRepository});
  Future<AdviceResponseEntity?> execute() async {
    return breachRepository.fetchAdvice();
  }
}
