part of 'vault_bloc.dart';

@immutable
sealed class VaultState {}

final class VaultInitial extends VaultState {}

final class VaultPresenceCheckingState extends VaultState {}

final class VaultPresentState extends VaultState {}

final class VaultNotPresentState extends VaultState {}

final class VaultPresenceCheckingErrorState extends VaultState {}

final class VaultCreatingState extends VaultState {}

final class VaultCreatedState extends VaultState {
  final String masterKey;
  VaultCreatedState({required this.masterKey});
}

final class VaultcreateErrorState extends VaultState {}

final class ClosedVaultState extends VaultState {}

final class OpeningVaultState extends VaultState {}

final class OpenedVaultState extends VaultState {
  final List<Map<String, String>> secrets;
  OpenedVaultState({required this.secrets});
}

final class OpenFailureVaultState extends VaultState {}

final class VaultRefreshingState extends VaultState {}

final class VaultRefreshedState extends VaultState {}

final class VaultRefreshErrorState extends VaultState {}

final class ItemAddingState extends VaultState {}

final class ItemSuccessfullyAdded extends VaultState {}

final class ItemNotAddedState extends VaultState {}

final class ItemUpdatingState extends VaultState {}

final class ItemSuccessfullyUpdated extends VaultState {}

final class ItemNotUpdatedState extends VaultState {}

final class ItemDeletingState extends VaultState {}

final class ItemSuccessfullyDeleted extends VaultState {}

final class ItemNotDeletedState extends VaultState {}
