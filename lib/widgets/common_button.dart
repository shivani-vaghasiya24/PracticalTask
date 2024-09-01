import 'package:flutter/material.dart';
import 'package:practical_task_2/Utils/app_colors.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key,
      required this.text,
      this.buttonColor,
      this.textColor,
      this.fontWeight,
      this.margin,
      this.padding});
  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primaryColor)),
      margin: margin,
      child: Padding(
        padding: padding ?? EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: textColor,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
