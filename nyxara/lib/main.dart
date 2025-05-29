import 'package:nyxara/data/datasources/user_datasource.dart';

Future<void> main() async {
  const email = 'testuser@nyxara.com';
  const password = 'securePass123';
  final NyxaraDB nyxaraDB = NyxaraDB();
  // Test create user
  final createdUser = await nyxaraDB.createUser(email, password);
  if (createdUser != null) {
    print("✅ User created: ${createdUser.email}");
  } else {
    print("❌ Failed to create user.");
  }

  // Test get user

  // Test check user credentials
  final validatedUser = await nyxaraDB.checkUser(email, password);
  if (validatedUser != null) {
    print("✅ User credentials valid for: ${validatedUser}");
  } else {
    print("❌ Invalid user credentials.");
  }
  print("🔌 Connection closed.");
}
