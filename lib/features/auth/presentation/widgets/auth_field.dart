import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  const AuthField({super.key, required this.hintText, required this.controller, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText
      ),
      validator: (value) {
        if (value!.isEmpty){
          return "$hintText is missing";
        }else{
          return null;
        }
      },
    );
  }
}
