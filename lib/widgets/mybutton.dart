import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  const Mybutton({
    super.key,
    required this.color,
    required this.buttonText,
    required this.textColor,
    required this.onTap,
  });

  final Color color;
  final String buttonText;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(0.2),
        child: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
            ),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                    color: textColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
