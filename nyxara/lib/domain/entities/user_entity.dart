class UserEntity {
  final String email;
  final String password;

  UserEntity({
    required this.email,
    required this.password,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
