import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomElevatedButton extends StatelessWidget {
  final SvgPicture? icon;
  final String text;
  final Color? color;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color? textColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? borderColor;

  const CustomElevatedButton({
    super.key,
    required this.text,
     this.color,
    required this.onPressed,
    this.width = 350,
    this.height = 50,
    this.icon,
    this.textColor = Colors.white,
    this.elevation,
    this.shadowColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(

        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          shadowColor: shadowColor,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(color: borderColor ?? Colors.transparent),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
