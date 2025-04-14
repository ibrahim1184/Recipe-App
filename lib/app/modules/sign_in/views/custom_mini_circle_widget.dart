// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomCircleWidget extends StatelessWidget {
  final double size;
  final Color color;
  final Widget child;
  const CustomCircleWidget({
    super.key,
    required this.size,
    required this.color,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: child,
      ),
    );
  }
  
}
