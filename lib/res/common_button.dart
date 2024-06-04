import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback ontap;
  final Widget child;
  const CustomButton({
    super.key,
    required this.ontap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Colors.deepPurpleAccent,
              Colors.redAccent,
              Colors.orangeAccent,
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
