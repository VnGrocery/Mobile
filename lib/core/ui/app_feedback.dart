import 'package:flutter/material.dart';

class AppFeedback {
  const AppFeedback._();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
