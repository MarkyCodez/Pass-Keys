import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isObcure;
  final void Function() onPressed;
  const MyPasswordField({
    super.key,
    required this.controller,
    required this.hint,
    required this.isObcure,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      obscureText: isObcure,
      controller: controller,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: onPressed,
          child: Icon(isObcure
              ? CupertinoIcons.eye_slash_fill
              : CupertinoIcons.eye_fill),
        ),
        label: Text(hint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
