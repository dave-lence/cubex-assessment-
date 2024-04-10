import 'package:cubex_app/config/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool obscureText;
  final suffixIcon;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.suffixIcon
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide(
              color: CustomColor().appRed,
              width: 1,
            )),
        filled: true,
        fillColor: CustomColor().appWhite,
        hintText: widget.labelText,
         
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide.none),
      ),
      validator: widget.validator,
    );
  }
}
