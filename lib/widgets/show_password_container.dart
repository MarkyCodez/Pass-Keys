import 'package:flutter/material.dart';
import 'package:password_manager/theme/my_colors.dart';

class ShowPasswordContainer extends StatefulWidget {
  final String site;
  final TextEditingController control;
  const ShowPasswordContainer({
    super.key,
    required this.site,
    required this.control,
  });

  @override
  State<ShowPasswordContainer> createState() => _ShowPasswordContainerState();
}

class _ShowPasswordContainerState extends State<ShowPasswordContainer> {
  void func() {
    widget.control.text = widget.site;
  }

  @override
  void initState() {
    func();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    func();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        onChanged: (value) {
          widget.control.text = value;
        },
        controller: widget.control,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: MyColors.whiteColor,
          filled: true,
        ),
      ),
    );
  }
}
