import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
              child: Text('Login with Google'),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = await _authService.signInWithGitHub();
                if (user != null) {
                  Navigator.pushReplacementNamed(context, '/diary');
                }
              },
              child: Text('Login with GitHub'),
            ),
          ],
        ),
      ),
    );
  }
}
