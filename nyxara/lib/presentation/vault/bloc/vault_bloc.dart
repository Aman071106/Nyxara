import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:nyxara/domain/usecases/check_vault_usecase.dart';
import 'package:nyxara/domain/usecases/create_vault_usecase.dart';
import 'package:nyxara/domain/usecases/fetch_vault_items_usecase.dart';
import 'package:nyxara/domain/usecases/verify_masterkey_usecase.dart';

part 'vault_event.dart';
part 'vault_state.dart';

class VaultBloc extends Bloc<VaultEvent, VaultState> {
  final Checkvaultusecase checkvaultusecase;
  final Createvaultusecase createvaultusecase;
  final FetchVaultItemsUsecase fetchVaultItemsUsecase;
  final VerifyMasterkeyUsecase verifyMasterkeyUsecase;
  VaultBloc({
    required this.checkvaultusecase,
    required this.createvaultusecase,
    required this.fetchVaultItemsUsecase,
    required this.verifyMasterkeyUsecase,
  }) : super(VaultInitial()) {
    on<VaultCheckEvent>(_vaultCheck);
    on<VaultCreateEvent>(_vaultCreate);
    on<PopMasterKeyEvent>(_popDialog);
    on<VaultOpenEvent>(_vaultopen);
    on<VaultCloseEvent>(_vaultclose);
  }

  Future<void> _vaultCheck(
    VaultCheckEvent event,
    Emitter<VaultState> emit,
  ) async {
    emit(VaultPresenceCheckingState());
    try {
      bool Ispresent = await checkvaultusecase.execute(event.email);
      if (Ispresent) {
        emit(VaultPresentState());
      } else {
        emit(VaultNotPresentState());
      }
    } catch (e) {
      log("Eroor checking vault presence in bloc $e");
      emit(VaultPresenceCheckingErrorState());
    }
  }

  Future<void> _vaultCreate(
    VaultCreateEvent event,
    Emitter<VaultState> emit,
  ) async {
    emit(VaultCreatingState());
    try {
      final masterKey = await createvaultusecase.execute(
        event.masterKey,
        event.email,
      );
      if (masterKey != null) {
        emit(VaultCreatedState(masterKey: masterKey));
      } else {
        emit(VaultcreateErrorState());
        emit(VaultNotPresentState());
      }
    } catch (e) {
      log("Error creating vault speaking from bloc");
      emit(VaultcreateErrorState());
      emit(VaultNotPresentState());
    }
  }

  Future<void> _popDialog(
    PopMasterKeyEvent event,
    Emitter<VaultState> emit,
  ) async {
    emit(VaultPresentState());
  }

  Future<void> _vaultopen(
    VaultOpenEvent event,
    Emitter<VaultState> emit,
  ) async {
    emit(OpeningVaultState());

    if (!(await verifyMasterkeyUsecase.execute(event.masterKey, event.email))) {
      log("YES");
      emit(OpenFailureVaultState());
      emit(VaultPresentState());
      return;
    }
    try {
      log("Inside bloc 1...");

      var items = await fetchVaultItemsUsecase.execute(event.email);
      log("Inside bloc...");
      log(items.toString());
      if (items != null) {
        emit(OpenedVaultState(secrets: items));
      } else {
        emit(OpenFailureVaultState());
        emit(VaultPresentState());
      }
    } catch (e) {
      log("Error opening vault... in bloc");
      emit(OpenFailureVaultState());
      emit(VaultPresentState());
    }
  }

  Future<void> _vaultclose(
    VaultCloseEvent event,
    Emitter<VaultState> emit,
  ) async {
    emit(ClosedVaultState());
    emit(VaultPresentState());
  }
}
