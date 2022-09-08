import 'package:flutter/material.dart';
import 'package:stdev/utils/validators.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({Key? key, this.enable, this.controller, this.keyboardType, this.textInputAction, this.maxLines, this.isEmailValidator, this.icon, this.prefixIcon, this.labelText, this.obscureText}) : super(key: key);

  final bool? enable;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final bool? isEmailValidator;
  final Widget? icon;
  final Widget? prefixIcon;
  final String? labelText;
  final bool? obscureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enabled: widget.enable,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        obscureText: widget.obscureText ?? false,
        validator: (value) {
          if (widget.isEmailValidator!) {
            return Validators.isEmailValid(value ?? '');
          } else {
            return Validators.isTextEmpty(value ?? '');
          }
        },
        decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            labelText: widget.labelText,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.blue),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.blue),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 1),
            )));
  }
}
