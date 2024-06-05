import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.onValueChanged,
    this.width,
    this.suffixIcon,
    this.height,
    this.hintText,
    this.keyboardType,
    this.obscureText,
    this.textAlignVertical,
    this.inputController,
    this.borderCircular = true,
  });

  final double? width;
  final Icon? suffixIcon;
  final double? height;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final TextEditingController? inputController;
  final bool borderCircular;
  final TextAlignVertical? textAlignVertical;
  final void Function(String)? onValueChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 40,
      child: TextFormField(
        controller: inputController,
        textAlign: TextAlign.start,
        textAlignVertical: textAlignVertical ?? TextAlignVertical.bottom,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        onChanged: onValueChanged,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          suffixIconColor: Colors.grey,
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: borderCircular
                ? const BorderRadius.all(Radius.circular(5))
                : const BorderRadius.all(Radius.zero),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderCircular
                ? const BorderRadius.all(Radius.circular(5))
                : const BorderRadius.all(Radius.zero),
            borderSide: const BorderSide(
              color: Colors.green,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
