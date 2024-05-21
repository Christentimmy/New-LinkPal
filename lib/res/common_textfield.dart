import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final int? maxline;
  final TextEditingController controller;
  final bool isObscureText;
  final IconData icon;
  final TextInputAction? action;
  final TextInputType? type;
  final VoidCallback? suffixTap;
  final IconData? suffixICon;
  final String? Function(String?)? passwordValidator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isObscureText,
    required this.icon,
    this.suffixTap,
    this.suffixICon,
    this.action,
    this.type,
    this.passwordValidator,
    this.maxline,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      validator: passwordValidator ??
          (value) {
            if (value!.isEmpty) {
              return "Field is required";
            }
            return null;
          },
      obscureText: isObscureText,
      maxLines: maxline ?? 1,
      textAlign: TextAlign.start,
      textInputAction: action ?? TextInputAction.done,
      keyboardType: type,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          fontSize: 13,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        labelText: hintText,
        prefixIcon: Icon(icon, size: 18),
        suffixIcon: IconButton(
          onPressed: suffixTap,
          icon: Icon(suffixICon, size: 18,),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.orangeAccent,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}

class CustomBioTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final IconData icon;
  final TextInputAction? action;
  final TextInputType? type;
  final VoidCallback? suffixTap;
  final IconData? suffixICon;
  final String? Function(String?)? passwordValidator;

  const CustomBioTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isObscureText,
    required this.icon,
    this.suffixTap,
    this.suffixICon,
    this.action,
    this.type,
    this.passwordValidator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      validator: passwordValidator ??
          (value) {
            if (value!.isEmpty) {
              return "Field is required";
            }
            return null;
          },
      obscureText: isObscureText,
      maxLines: 3,
      textInputAction: action ?? TextInputAction.done,
      keyboardType: type,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        labelText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: IconButton(
          onPressed: suffixTap,
          icon: Icon(suffixICon),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.orangeAccent,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
