import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nyxara/core/router/routes_consts.dart';
import 'package:nyxara/data/datasources/user_datasource.dart';
import 'package:nyxara/presentation/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreen();
}

class _AuthScreen extends State<AuthScreen> {
  late NyxaraDB _nyxaraDB;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  String buttonStateText = "Login";
  bool wantsToLogin = true;

  @override
  void initState() {
    _nyxaraDB = NyxaraDB();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authentication")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.goNamed(NyxaraRoutes.dashboardRoute);
          }
        },
        builder: (context, state) {
          if (state is Logging || state is SigningUp) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty) {
                        if (wantsToLogin) {
                          context.read<AuthBloc>().add(
                            LoginRequested(email: email, password: password),
                          );
                        } else {
                          context.read<AuthBloc>().add(
                            SignUpRequested(email: email, password: password),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter email and password"),
                          ),
                        );
                      }
                    },
                    child: Text(wantsToLogin ? "Login" : "Sign Up"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        wantsToLogin = !wantsToLogin;
                      });
                    },
                    child: Text(
                      wantsToLogin ? "Switch to Sign Up" : "Switch to Login",
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
