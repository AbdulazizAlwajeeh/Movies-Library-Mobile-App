import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    required this.validator,
    required this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final bool obscureText;
  final void Function(String value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 7),
      child: TextFormField(
        onChanged: onChanged,
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          // Optional: Adds an icon inside the text field
          border: OutlineInputBorder(
            // Rounded borders
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
      ),
    );
  }
}
