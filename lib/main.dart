import 'package:flutter/material.dart';
import 'package:my_toast/home_page.dart';
import 'package:my_toast/toast/toast_warpper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ToastWrapper(child: HomePage()),
    );
  }
}
