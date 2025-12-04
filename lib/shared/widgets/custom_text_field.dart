import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom text field widget
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      enabled: enabled,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        counterText: maxLength != null ? null : '',
      ),
    );
  }
}

/// Password text field with visibility toggle
class PasswordTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const PasswordTextField({
    super.key,
    this.label = 'Password',
    this.controller,
    this.validator,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
