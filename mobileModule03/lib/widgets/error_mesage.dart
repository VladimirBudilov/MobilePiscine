import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message = "Invalid or empty city name. Please try again.";

  const ErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}