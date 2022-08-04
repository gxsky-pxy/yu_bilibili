import 'package:flutter/material.dart';
import 'package:yu_bilibili/util/color.dart';

class LoginButton extends StatefulWidget {
  final String title;
  final bool enable;
  final VoidCallback? onPressed;
  const LoginButton(this.title, {Key? key, this.enable = false, this.onPressed})
      : super(key: key);

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: MaterialButton(
        onPressed: widget.enable ? widget.onPressed : null,
        disabledColor: primaryColor[50],
        color: primaryColor,
        height: 45,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Text(widget.title,
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
