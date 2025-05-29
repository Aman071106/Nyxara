import 'package:flutter/material.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});
  @override
  createState() => _VaultScreen();
}

class _VaultScreen extends State<VaultScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Vault"));
  }
}
