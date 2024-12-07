import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              Navigator.pushReplacementNamed(context, '/diary');
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}
