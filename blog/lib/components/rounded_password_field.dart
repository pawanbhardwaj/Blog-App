import 'package:blog/components/text_field_container.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _obscureFlag = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: _obscureFlag,
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: GestureDetector(
              child: !_obscureFlag
                  ? Icon(
                      Icons.remove_red_eye,
                      color: kPrimaryColor,
                    )
                  : Icon(
                      Icons.visibility_off,
                      color: kPrimaryColor,
                    ),
              onTap: () {
                setState(() => _obscureFlag = !_obscureFlag);
                // print(_obscureFlag);
              }),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
