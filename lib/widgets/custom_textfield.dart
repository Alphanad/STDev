import 'package:flutter/material.dart';
import 'package:stdev/utils/validators.dart';

class CustomTextField extends StatefulWidget {
  final bool? enable;
  final int? maxLines;
  final bool? obscureText;
  final String? labelText;
  final Widget? prefixIcon;
  final bool? isEmailValidator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;

  const CustomTextField({Key? key, this.enable, this.maxLines, this.obscureText, this.labelText, this.prefixIcon, this.isEmailValidator, this.keyboardType, this.textInputAction, this.controller}) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enabled: widget.enable,
        controller: widget.controller,
        maxLines: widget.maxLines ?? 1,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText ?? false,
        validator: (value) {
          if (widget.isEmailValidator!) {
            return Validators.isEmailValid(value ?? '');
          } else {
            return Validators.isTextEmpty(value ?? '');
          }
        },
        decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: widget.prefixIcon,
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
            )
        )
    );
  }
}
