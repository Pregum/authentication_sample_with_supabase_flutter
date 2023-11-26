import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final String label;
  final TextEditingController controller;
  const MyTextField({
    super.key,
    this.hintText = '',
    this.label = '',
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        label: Text(label),
      ),
      controller: controller,
    );
  }
}
