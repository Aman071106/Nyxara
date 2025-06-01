part of 'vault_bloc.dart';

@immutable
sealed class VaultEvent {}

final class VaultCheckEvent extends VaultEvent {
  final String email;
  VaultCheckEvent({required this.email});
}

final class VaultCreateEvent extends VaultEvent {
  final String masterKey;
  final String email;
  VaultCreateEvent({required this.masterKey, required this.email});
}

final class VaultOpenEvent extends VaultEvent {
  final String masterKey;
  final String email;
  VaultOpenEvent({required this.masterKey, required this.email});
}

final class VaultCloseEvent extends VaultEvent {}

final class VaultAddEvent extends VaultEvent {
  final String email;
  final String title;
  final String key;
  final String masterKey;
  final String value;
  VaultAddEvent({
    required this.email,
    required this.title,
    required this.key,
    required this.masterKey,
    required this.value,
  });
}

final class VaultUpdateEvent extends VaultEvent {
  final String email;
  final String title;
  final String key;
  final String masterKey;
  final String newValue;

  VaultUpdateEvent({
    required this.email,
    required this.title,
    required this.key,
    required this.masterKey,
    required this.newValue,
  });
}

final class DeleteItemEvent extends VaultEvent {
  final String email;
  final String title;
  final String key;
  final String masterKey;
  DeleteItemEvent({
    required this.email,
    required this.title,
    required this.key,
    required this.masterKey,
  });
}

final class RevealValueEvent extends VaultEvent {
  final String masterKey;

  final String encryptedValue;
  RevealValueEvent({required this.masterKey, required this.encryptedValue});
}

final class PopMasterKeyEvent extends VaultEvent{}