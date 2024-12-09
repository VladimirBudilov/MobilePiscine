import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final user = await _authService.signInWithGoogle();
                if (user != null) {
                  Navigator.pushReplacementNamed(context, '/diary');
                }
              },
              child: const Text('Login with Google'),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = await _authService.signInWithGitHub();
                if (user != null) {
                  Navigator.pushReplacementNamed(context, '/diary');
                }
              },
              child: const Text('Login with GitHub'),
            ),
          ],
        ),
      ),
    );
  }
}
