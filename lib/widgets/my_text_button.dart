import 'package:flutter/material.dart';
import 'package:password_manager/theme/my_colors.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const MyTextButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        text,
        style: TextStyle(color: MyColors.whiteColor),
      ),
    );
  }
}
