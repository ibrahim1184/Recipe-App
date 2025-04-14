import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipe_app_firebase/colors.dart';
import 'package:recipe_app_firebase/typography.dart';

class CustomTextFormField extends StatelessWidget {
  final Color? fillColor;
  final bool? filled;
  final SvgPicture? prefixIcon;
  final String hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final Color? focusedBorderColor;
  final Color? borderColor;
  final TextCapitalization textCapitalization;

  const CustomTextFormField({
    this.fillColor,
    this.filled,
    this.controller,
    super.key,
    this.prefixIcon,
    required this.hintText,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.textInputAction,
    this.focusedBorderColor,
    this.borderColor,
    this.textCapitalization = TextCapitalization.sentences,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 50,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          fillColor: fillColor,
          filled: filled,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: focusedBorderColor ?? AppColors.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? AppColors.outline,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: prefixIcon,
                    ),
                  ),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          hintText: hintText,
          hintStyle: AppTypography.bodyText2.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}
