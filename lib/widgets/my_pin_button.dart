import 'package:flutter/material.dart';
import 'package:password_manager/widgets/my_button.dart';

class MyPinButton extends StatelessWidget {
  final TextEditingController pinController;
  final String text;
  final String buttonText;
  final void Function()? onTap;
  const MyPinButton({
    super.key,
    required this.pinController,
    required this.text,
    required this.buttonText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: TextField(
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                controller: pinController,
                decoration: InputDecoration(
                  labelText: text,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    onTap!();
                    Navigator.pop(context);
                  },
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      text: text,
    );
  }
}
