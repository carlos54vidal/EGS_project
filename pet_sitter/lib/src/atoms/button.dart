import 'package:flutter/material.dart';
import 'package:pet_sitter/src/constants/constant_colors.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.width,
    this.height,
    this.textColor,
    this.fontSize,
    this.borderColor,
    this.borderCircular = true,
  });

  final String label;
  final bool borderCircular;
  final Function()? onTap;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 346,
        height: height ?? 54,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).primaryColor,
          border: borderColor != null
              ? Border.all(color: borderColor!)
              : Border.all(color: Theme.of(context).cardColor),
          borderRadius: borderCircular
              ? const BorderRadius.all(Radius.circular(5))
              : const BorderRadius.all(Radius.zero),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(17, 24, 39, 0.07),
              blurRadius: 34,
              offset: Offset(8, 14),
            )
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor ??
                  Theme.of(context).textTheme.labelLarge?.color ??
                  Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 20,
            ),
          ),
        ),
      ),
    );
  }
}
