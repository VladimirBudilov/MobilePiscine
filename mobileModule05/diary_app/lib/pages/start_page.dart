import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/background_login.webp"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Life Log',
                style: TextStyle(
                  fontSize: 42,
                  fontFamily: 'StrangeFont',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 42, 69, 113),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, '/diary');
                  } else {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                child: const Text('Login', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
