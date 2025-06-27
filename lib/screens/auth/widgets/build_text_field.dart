import 'package:flutter/material.dart';

class BuildTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final String? Function(String?)? validator;

  const BuildTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && !_isPasswordVisible,
      validator: widget.validator,
      style: const TextStyle(
        color: Color(0xFF1F1F1F),
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: const Color(0xFF1F1F1F).withOpacity(0.5),
          fontSize: 16,
        ),
        prefixIcon: Icon(
          widget.icon,
          color: const Color(0xFF1F1F1F).withOpacity(0.6),
          size: 20,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF1F1F1F).withOpacity(0.6),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF3E8F3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(
            color: Color(0xFF543855),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }
}
