import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'vault_event.dart';
part 'vault_state.dart';

class VaultBloc extends Bloc<VaultEvent, VaultState> {
  VaultBloc() : super(VaultInitial()) {
    on<VaultEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
